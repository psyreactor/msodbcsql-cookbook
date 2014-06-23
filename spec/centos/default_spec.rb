# Encoding: utf-8

require_relative '../spec_helper'

describe 'msodbcsql::default ' do
  let(:chef_run) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '6.5'
      ) do |node|
      node.set[:msodbcsql][:version] = '11.0.2270.0'
    end.converge('msodbcsql::default')
  end

  before do
    stub_command('odbcinst --version | grep 2.3.0').and_return(false)
    stub_command('sqlcmd | grep 11.0.2270.0').and_return(false)
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('inifile').and_return(true)
    allow(Dir).to receive(:exist?).and_call_original
    allow(Dir).to receive(:exist?).with("#{Chef::Config[:file_cache_path]}/unixODBC-2.3.0").and_return(false)
  end

  it 'includes depends recipe' do
    expect(chef_run).to include_recipe('build-essential::default')
    expect(chef_run).to include_recipe('yum-epel::default')
  end

  it 'install gem required for cookbook' do
    expect(chef_run).to install_gem_package('inifile')
  end

  it 'load gem required for cookbook' do
    expect(chef_run).to run_ruby_block('inifile_load')
  end

  it 'install packages required for tiny-tds' do
    expect(chef_run).to install_package('freetds')
    expect(chef_run).to install_package('freetds-devel')
  end

  it 'install tiny_tds gem' do
    expect(chef_run).to install_gem_package('tiny_tds')
  end

  it 'download unixODBC source File' do
    expect(chef_run).to create_remote_file_if_missing("#{Chef::Config[:file_cache_path]}/unixODBC-2.3.0.tar.gz")
  end

  it 'extract unixODBC' do
    expect(chef_run).to run_execute('UnixODBC_extract')
  end

  it 'configure unixODBC' do
    expect(chef_run).to run_execute('UnixODBC_configure')
  end

  it 'make build unixODBC' do
    expect(chef_run).to run_execute('UnixODBC_make')
  end

  it 'download msodbcsql source File' do
    expect(chef_run).to create_remote_file_if_missing("#{Chef::Config[:file_cache_path]}/msodbcsql-11.0.2270.0.tar.gz")
  end

  it 'extract msodbcsql' do
    expect(chef_run).to run_execute('msodbcsql_extract')
  end

  it 'install msodbcsql' do
    expect(chef_run).to run_execute('msodbcsql_install')
  end

end
