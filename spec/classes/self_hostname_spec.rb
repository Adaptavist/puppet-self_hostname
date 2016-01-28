require 'spec_helper'

describe 'self_hostname', :type => 'class' do
  hostname = "hostname"
  fqdn     = "#{hostname}.example.com" 
  context "Should set 127.0.1.1 to localhost and ::hostname" do
    let(:facts){{
      :hostname => hostname,
      :fqdn     => fqdn,
      }}
    it do
      should contain_host(fqdn).with(
          'ensure'       => 'present',
          'ip'           => '127.0.1.1',
          'host_aliases' => [hostname, 'localhost'],
        )
        
    end
  end
  context "Should remove 127.0.1.1 from hosts" do
    let(:facts){{
      :hostname => hostname,
      :fqdn     => fqdn,
      }}
    let(:params) {{
      :remove_hostname => 'true',
      }}
    it do
      should contain_augeas('removal_in_etc_hosts').with(
          'context' => '/files/etc/hosts',
          'changes' => [
            "rm *[ipaddr = '127.0.1.1']",
          ]
        )
        
    end
  end
  context "Should set 127.0.0.1 to localhost and not to hostname" do
    let(:facts){{
      :hostname => hostname,
      :fqdn     => fqdn,
      }}
    let(:params) {{
      :ensure_canonical_hostname => 'true',
      }}
    it do
      should contain_host(hostname).with(
          'ensure'       => 'absent',
          'ip'           => '127.0.0.1',
        )
      should contain_host('localhost').with(
          'ensure'       => 'present',
          'ip'           => '127.0.0.1',
        )
    end
  end
end
