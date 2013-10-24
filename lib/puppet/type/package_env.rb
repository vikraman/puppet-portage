require_relative '../property/portage_version'
require_relative '../property/portage_slot'
require_relative '../parameter/portage_name'
require_relative '../util/portage'

Puppet::Type.newtype(:package_env) do
  @doc = "Set environment variables for a package.

      package_env { 'dev-libs/boost':
        env    => ['no-distcc', 'single-build-thread'],
        target => 'boost',
      }"

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true, :parent => Puppet::Parameter::PortageName)

  newproperty(:version, :parent => Puppet::Property::PortageVersion)

  newproperty(:slot, :parent => Puppet::Property::PortageSlot)

  newproperty(:env) do
    desc "The env files to apply"

    defaultto []

    def insync?(is)
      is == @should
    end

    def should
      if defined? @should
        if @should == [:absent]
          return :absent
        else
          return @should
        end
      else
        return nil
      end
    end

    def should_to_s(newvalue = @should)
      newvalue.join(" ")
    end

    def is_to_s(currentvalue = @is)
      currentvalue = [currentvalue] unless currentvalue.is_a? Array
      currentvalue.join(" ")
    end

  end

  newproperty(:target) do
    desc "The location of the package.env file"

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
        value = "/etc/portage/package.env/" + value
      end
      value
    end
  end
end
