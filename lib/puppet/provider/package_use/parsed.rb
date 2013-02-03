require 'puppet/provider/portagefile'
require 'puppet/util/portage'

Puppet::Type.type(:package_use).provide(:parsed,
  :parent => Puppet::Provider::PortageFile,
  :default_target => "/etc/portage/package.use/default",
  :filetype => :flat
) do

  desc "The package_use provider that uses the ParsedFile class"

  record_line :parsed, :fields => %w{name use},
    :joiner => ' ',
    :rts  => true do |line|
    hash = {}
    if (match = line.match /^(\S+)\s+(.*)\s*$/)
      components = Puppet::Util::Portage.parse_atom(match[1])

      # Try to parse version string
      if components[:compare] and components[:version]
        v = components[:compare] + components[:version]
      end

      hash[:name]    = components[:package]
      hash[:version] = v
      use            = match[2]

      if use
        hash[:use] = use.split(/\s+/)
      end

    elsif (match = line.match /^(\S+)\s*/)
      # just a package
      hash[:name] = match[1]
    else
      raise Puppet::Error, "Could not match '#{line}'"
    end

    hash
  end

  def self.to_line(hash)
    build_line(hash, :use)
  end
end
