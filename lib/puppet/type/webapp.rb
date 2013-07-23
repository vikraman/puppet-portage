Puppet::Type.newtype(:webapp) do

  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the webapp."
  end

  newproperty(:appname) do
    desc "The name of the package to install"
  end

  newproperty(:appversion) do
    desc "The version of the package to install"
  end

  newproperty(:server) do
    desc "The web server used to access the webapp."
  end

  # newproperty(:user) do
  #   desc "The user who owns installed configuration files."
  # end

  # newproperty(:group) do
  #   desc "The group which owns installed configuration files."
  # end

  newproperty(:dir) do
    desc "The directory where the webapp is installed."
  end

  newproperty(:host) do
    desc "The fqdn of the virtual host."
  end

  # newproperty(:soft) do
  #   desc "Whether to use softlinks."
  #   defaultto :no
  #   newvalues(:yes, :no)
  # end

  newproperty(:secure) do
    desc "Whether to use htdocs-secure instead of htdocs."
    defaultto :no
    newvalues(:yes, :no)
  end
end
