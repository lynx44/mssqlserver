require 'chefspec'

describe 'mssqlserver::server' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs .net 3.5 feature' do
    expect(chef_run).to install_feature("NetFx3")
  end
end