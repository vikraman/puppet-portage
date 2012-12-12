module Puppet::Util::Portage
  # Util methods for Portage types and providers.
  #
  # @see http://dev.gentoo.org/~zmedico/portage/doc/man/ebuild.5.html 'man 5 ebuild section DEPEND'

  # Determine if a string is a valid DEPEND atom
  #
  # @param [String] atom The string to validate as a DEPEND atom
  #
  # @return [TrueClass]
  # @return [FalseClass]
  def self.valid_atom?(atom)
    atom_prefix  = '(?:[<>=]|[<>]=)'
    atom_name    = '(?:[a-zA-Z-]+/[a-zA-Z-]+?)'
    atom_version = '(?:-[\d.]+[\w-]+)'

    base_atom      = Regexp.new("^#{atom_name}$")
    versioned_atom = Regexp.new("^#{atom_prefix}#{atom_name}#{atom_version}$")
    depend         = Regexp.union(base_atom, versioned_atom)

    # Normalize the regular expression output to a boolean
    !!(atom =~ depend)
  end

  # Determine if a string is a valid package name
  #
  # @param [String] package_name the string to validate as a package name
  #
  # @return [TrueClass]
  # @return [FalseClass]
  def self.valid_package?(package_name)
    package_pattern  = '(?:[\w-]+/(:?[\w-]+\w)?)'

    regex = Regexp.new(%[^#{package_pattern}$])

    !!(package_name =~ regex)
  end

  # Determine if a string is a valid DEPEND atom version
  #
  # This validates a standalone version string. The format is an optional
  # comparator and a version string.
  #
  # @param [String] version_str The string to validate as a version string.
  #
  # @return [TrueClass]
  # @Return [FalseClass]
  def self.valid_version?(version_str)

    compare_pattern = '(?:[<>=~]|[<>]=)'
    version_pattern = '(?:[\d.]+[\w-]+)'

    regex = Regexp.new(%[^#{compare_pattern}?#{version_pattern}$])

    !!(version_str =~ regex)
  end
end
