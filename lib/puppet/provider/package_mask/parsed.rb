require 'puppet/provider/portagefile'
require 'puppet/util/portage'

Puppet::Type.type(:package_mask).provide(:parsed,
  :parent => Puppet::Provider::ParsedFile,
  :default_target => "/etc/portage/package.mask/default",
  :filetype => :flat
) do

  desc "The package_mask provider backed by parsedfile"
  record_line :parsed, :fields => %w{name}, :rts => true do |line|
    hash = {}
    if (match = line.match /^(\S+)\s*/)
      # just a package
      components = Puppet::Util::Portage.parse_atom(match[1])

      # Try to parse version string
      if components[:compare] and components[:version]
        v = components[:compare] + components[:version]
      end

      hash[:name]    = components[:package]
      hash[:version] = v
    else
      raise Puppet::Error, "Could not match '#{line}'"
    end

    hash
  end
end
