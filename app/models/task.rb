require 'fileutils'

class Task < ApplicationRecord
  extend FriendlyId
  friendly_id :name
  belongs_to :user
  belongs_to :env_group
  has_many :jobs
  validates_format_of :name, with: /\A[a-z0-9\-_]+\Z/i
  validates :name, uniqueness: true
  validates :user, presence: true

  before_save :generate_all_scripts
  before_create :make_sure_author

  attr_reader :import_logs

  def timeout
    env_group && env_group.envs.find_by(key: 'TIMEOUT').try(:value)
  end

  def cwd
    env_group && env_group.envs.find_by(key: 'CWD').try(:value)
  end

  def start_new_job(user)
    raise Expcetion.new('You don\'t have permission to run this task.') if admin_only? && !user.admin?
    raise Exception.new('There is a job is running. please wait that job finish and try again.') if Runner.instance.running?
    job = jobs.create(user: user)
    Runner.instance.run job
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
    # f.puts %|set -e|
    # f.puts %|trap 'kill -s INT 0' EXIT|
    env_group && env_group.envs.each do |env|
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

  def version_greater_than(ver)
    Gem::Version.new(version) > Gem::Version.new(ver)
  end

  def self.import(hash, user)
    import_log = []
    task = Task.find_by(name: hash[:task][:name])
    attrs = hash[:task]
    if task && !task.version_greater_than(attrs[:version])
      return ["task #{attrs[:name]} version #{attrs[:version]} is less or equals than #{task.version}, Ignored."]
    end
    group = EnvGroup.find_by(name: hash[:env_group][:name]) if hash[:env_group]
    if group && hash[:env_group]
      hash[:env_group][:envs].each { |env|
        unless group.envs.find_by(key: env[:key])
          groups.envs.create(key: env[:key], value: env[:value])
          import_log << "Imported env #{env[:key]} with value #{env[:value]}."
        else
          import_log << "Env key #{env[:key]} already exists, ignored."
        end
      }
    end

    attrs.merge!(env_group: group, user: user)
    if task
      old_version = task.version
      task.update_attributes(attrs)
      import_log << "Task #{task.name} updated from #{old_version} to #{task.version}."
    else
      task = Task.create(attrs)
      import_log << "Imported new Task #{task.name}."
    end
    import_log
  end

  def self.import_from_yaml_file(file, user)
    import YAML.load(file.read), user
  end

  def to_h
    {
      env_group: env_group.to_h,
      task: {
        name: name, desc: desc, admin_only: admin_only, author: author,
        version: version, script: script
      }
    }
  end

  def export
    to_h.to_yaml
  end

  protected
  def make_sure_author
    if self.author.blank?
      self.author = user.email
    end
  end
end
