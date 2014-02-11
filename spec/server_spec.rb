require 'chefspec'
require_relative('../../../chefspec/config')

describe 'mssqlserver::server' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['mssqlserver']['server']['url'] = 'http://domain.com/test.zip'
    end
  end
  let(:converge) { chef_run.converge(described_recipe) }
  let(:node) { chef_run.node }

  it 'passes syntax check' do
    expect(chef_run)
  end
end