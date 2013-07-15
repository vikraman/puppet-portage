module Puppet::Util::Eselect
  # Util methods for Eselect types and providers.
  #

  extend self

  COMMANDS = {
    :eselect => '/usr/bin/eselect',
    :gcc_config => '/usr/bin/gcc-config'
  }

  # Builds a module combining the default and special modules
  #
  # @param [String] name The name of the module
  #
  # @return [Hash] The module
  def module(name)
    modules = {
      'gcc' => {
        :command => :gcc_config,
        :flags => ['--nocolor'],
        :param => nil,
        :get => ['-c'],
        :set => ['-f'],
      },
      'ruby' => {
        :parse => Proc.new { |x| x.split.first.strip },
      },
      'java-vm' => {
        :get => ['show', 'system'],
        :set => ['set', 'system'],
      },
      'python::python2' => {
        :param => 'python',
        :get => ['show', '--python2'],
        :set => ['set',  '--python2'],
      },
      'python::python3' => {
        :param => 'python',
        :get => ['show', '--python3'],
        :set => ['set',  '--python3'],
      },
    }
    modules.default={}
    default_module(name).merge(modules[name])
  end

  # Builds a default module
  #
  # @param [String] name The name of the module
  #
  # @return [Hash] The module
  private
  def default_module(name)
    {
      :command => :eselect,
      :flags => ['--brief', '--color=no'],
      :param => "#{name}",
      :get => ['show'],
      :set => ['set'],
      :parse => Proc.new { |x| x.strip },
    }
  end
end
