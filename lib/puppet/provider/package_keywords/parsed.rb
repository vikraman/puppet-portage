require 'puppet/provider/portagefile'
require 'puppet/util/portage'

Puppet::Type.type(:package_keywords).provide(:parsed,
  :parent => Puppet::Provider::PortageFile,
  :default_target => "/etc/portage/package.keywords/default",
  :filetype => :flat
) do

  desc "The package_keywords provider that uses the ParsedFile class"

  record_line :parsed, :fields => %w{name keywords},
    :joiner => ' ',
    :rts  => true do |line|
    hash = {}
    if (match = line.match /^(\S+)\s+(.*)\s*$/)
      # if we have a package and a keyword

      components = Puppet::Util::Portage.parse_atom(match[1])

      # Try to parse version string
      if components[:compare] and components[:version]
        v = components[:compare] + components[:version]
      end

      hash[:name]    = components[:package]
      hash[:version] = v
      keywords       = match[2]

      if keywords
        hash[:keywords] = keywords.split(/\s+/)
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
    return super unless hash[:record_type] == :parsed
    build_line(hash, :keywords)
  end
end
