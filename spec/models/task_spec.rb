require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'export to yaml and import from it' do
    user = FactoryGirl.create(:user)
    t = FactoryGirl.create(:task)
    yaml = t.export
    expect(yaml).to_not be_blank
    hash = YAML.load(yaml)
    expect(hash).to_not be_nil
    Task.all.delete(true)
    expect(Task.count).to be(0)
    Task.import(hash, user)
    expect(Task.count).to be(1)
    expect(Task.first.env_group).not_to be_nil
    expect(Task.first.env_group.envs.count).to be(2)
  end

  it 'compare with version' do
    t = Task.new(version: '1.0')
    expect(t.version_greater_than('0.1')).to be_truthy
    expect(t.version_greater_than('0.9')).to be_truthy
    expect(t.version_greater_than('1.0')).to be_falsey
    expect(t.version_greater_than('1.1')).to be_falsey
    expect(t.version_greater_than('2.0')).to be_falsey
  end
end
