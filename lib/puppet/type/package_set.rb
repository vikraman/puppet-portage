Puppet::Type.newtype(:package_set) do
  @doc = 'Type to install, update, and remove portage sets.'
  ensurable

  newparam(:name) do
    desc 'The name of the set without @'
    validate do | value |
      if value.match(/^@/)
        raise Puppet::Error, 'Set names should not begin with @ symbols'
      end
    end
  end
end
