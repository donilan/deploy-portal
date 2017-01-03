require 'fileutils'

class Task < ApplicationRecord
  extend FriendlyId
  friendly_id :name
  belongs_to :user
  belongs_to :env_group
  has_many :jobs
  validates_format_of :name, with: /\A[a-z0-9\-_]+\Z/i
  validates :name, uniqueness: true

  before_save :generate_all_scripts
  before_create :make_sure_author

  def start_new_job(user)
    job = jobs.create(user: user)
    Runner.current.run job
    job
  end

  def generate_all_scripts
    generate_script
    generate_raw_script
  end

  def generate_script
    FileUtils.mkdir_p(tasks_path) unless File.exist?(tasks_path)
    f = open(script_path, 'w+')
    f.chmod(0700)
    f.puts %|#!/bin/bash|
    f.puts %|set -e|
    f.puts %|trap 'kill -s INT 0' EXIT|
    env_group.envs.each do |env|
      f.puts %|export #{env.key}="#{env.value}"|
    end
    f.puts %|#{raw_script_path}|
    f.close
  end

  def generate_raw_script
    FileUtils.mkdir_p(raw_path) unless File.exist?(raw_path)
    f = open(raw_script_path, 'w+')
    f.chmod(0750)
    f.write self.script.gsub("\r", '')
    f.close
  end

  def script_path
    File.join(tasks_path, self.name)
  end

  def raw_script_path
    File.join(raw_path, self.name)
  end

  def raw_path
    File.join(tasks_path, 'raw')
  end

  def tasks_path
    Rails.root.join('tasks').to_s
  end
  protected
  def make_sure_author
    if self.author.blank?
      self.author = user.email
    end
  end
end
