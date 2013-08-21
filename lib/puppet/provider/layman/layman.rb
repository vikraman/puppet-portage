Puppet::Type.type(:layman).provide(:layman) do

  desc "The layman provider to manage overlays"

  commands :layman => '/usr/bin/layman'

  confine :operatingsystem => :gentoo
  defaultfor :operatingsystem => :gentoo

  def self.instances
    overlays =
      layman('--nocolor', '--quiet', '--list-local').
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
    layman('--quiet', '--add', resource[:name])
    @property_hash[:ensure] = :present
  end

  def destroy
    layman('--quiet', '--delete', resource[:name])
    @property_hash[:ensure] = :absent
  end
end
