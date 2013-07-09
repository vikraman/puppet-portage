require 'puppet/util/eselect'

Puppet::Type.type(:eselect).provide(:eselect) do

  confine :operatingsystem => :gentoo

  commands Puppet::Util::Eselect::COMMANDS

  def self.instances
    output = Facter.to_hash.keep_if { |key, value| (key =~ /^eselect_.+/) }
    output.map { |name, set| new(:name => name.sub(/^eselect_/, ''), :set => set) }
  end

  def set
    self.class.run_action_on_module(resource[:name], :get)
  end

  def set=(target)
    self.class.run_action_on_module(resource[:name], :set, target)
  end

  def self.run_action_on_module(name, action, *args)
    mod = Puppet::Util::Eselect.module(name)
    args = mod[:flags] + [mod[:param]] + mod[action] + args
    output = send(mod[:command], args.flatten.compact)
    mod[:parse].call(output)
  end
end
