require 'spec_helper'

describe 'newrelic::agent::java', type: :class do
  let(:facts) do
    {
      'os' => {
        'family'  => 'RedHat',
        'name'    => 'CentOS',
        'release' => {
          'major' => '7',
        },
      },
      'operatingsystem' => 'Centos',
      'path' => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/root/.local/bin:/root/bin',
    }
  end

  let(:params) do
    {
      license_key: '1234567890qwerty',
      manage_config: true,
      manage_unzip: true,
    }
  end

  it { is_expected.to compile }
  it { is_expected.to contain_package('unzip') }
  it { is_expected.to contain_exec('wget-newrelic-java-agent') }
  it { is_expected.to contain_exec('chown-newrelic-install-dir') }
  it { is_expected.to contain_exec('unzip-newrelic-java-agent-zip') }
  it { is_expected.to contain_file('/opt/newrelic/newrelic.yml') }
end
