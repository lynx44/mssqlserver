require 'chefspec'
require_relative('../../../chefspec/config')

describe 'mssqlserver::server' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'passes syntax check' do
    expect(chef_run)
  end
end