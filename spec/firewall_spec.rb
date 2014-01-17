require 'chefspec'
require_relative('../../../chefspec/config')

describe 'mssqlserver::firewall' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['mssqlserver']['server']['open_firewall_port'] = true
    end.converge(described_recipe)
  end

  it 'passes syntax check' do
    expect(chef_run)
  end
end