Puppet::Type.type(:layman).provide(:layman) do

  desc "The layman provider to manage overlays"

  commands :layman => '/usr/bin/layman'

  confine :operatingsystem => :gentoo
  defaultfor :operatingsystem => :gentoo

  def self.instances
    overlays =
      run_layman('--list-local').
      split("\n").map { |x| x.match(/\s+\*\s+(\S+).+/) }.
      compact.map { |x| x[1] }
    overlays.collect do |name|
      new(
        { :name => name,
          :ensure => :present,
        }
      )
    end
  end

  def self.prefetch(resources)
    overlays = instances
    resources.keys.each do |name|
      if provider = overlays.find { |overlay| overlay.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    self.class.run_layman('--add', resource[:name])
    @property_hash[:ensure] = :present
  end

  def destroy
    self.class.run_layman('--delete', resource[:name])
    @property_hash[:ensure] = :absent
  end

  def self.run_layman(*args)
    layman('--nocolor', '--quiet', args)
  end
end
