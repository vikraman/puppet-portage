require_relative '../property/portage_version'
require_relative '../property/portage_slot'
require_relative '../parameter/portage_name'
require_relative '../util/portage'

Puppet::Type.newtype(:package_mask) do
  @doc = "Mask packages in portage.

      package_mask { 'app-admin/chef':
        target  => 'chef',
      }"

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true, :parent => Puppet::Parameter::PortageName)

  newproperty(:version, :parent => Puppet::Property::PortageVersion)

  newproperty(:slot, :parent => Puppet::Property::PortageSlot)

  newproperty(:target) do
    desc "The location of the package.mask file"

    defaultto do
      if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
        @resource.class.defaultprovider.default_target
      else
        nil
      end
    end

    # Allow us to not have to specify an absolute path unless we really want to
    munge do |value|
      if !value.match(/\//)
        value = "/etc/portage/package.mask/" + value
      end
      value
    end
  end
end
