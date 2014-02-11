require 'chefspec'
require_relative('../../../chefspec/config')
require_relative('../../../chefspec_extensions/automatic_resource_matcher')

describe 'mssqlserver::restore_database' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  let(:converge) { chef_run.converge(described_recipe) }
  let(:node) { chef_run.node }

  it 'passes syntax check' do
    expect(chef_run)
  end

  it 'drops database' do
    node.set['mssqlserver']['restore']['drop'] = true

    expect(converge).to drop_mssqlserver_restore_database('restore sql database')
  end

  it 'does not drop database when flag not set' do
    node.set['mssqlserver']['restore']['drop'] = false

    expect(converge).to_not drop_mssqlserver_restore_database('restore sql database')
  end
end