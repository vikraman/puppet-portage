require 'fileutils'

Puppet::Type.type(:package_set).provide(:package_set) do
  @doc = 'Provider to install, update, and remove portage sets.'

  commands :emerge => '/usr/bin/emerge', :eix => '/usr/bin/eix'

  def create
    emerge "--noreplace", "@#{resource[:name]}"
  end

  def destroy
    emerge "--unmerge", "@#{resource[:name]}"
  end

  def exists?
    setfile = File.readlines('/var/lib/portage/world_sets')
    if setfile.size == 0 then
      return false
    end
    setfile.each do | line |
      if line == "@#{resource[:name]}\n" then
        installed_packages = eix '--nocolor', '--pure-packages', '--installed', '--format', '<category>/<name>\n'
        File.readlines("/etc/portage/sets/#{resource[:name]}").each do | pkg_line |
          next if pkg_line[0, 1] == '#'
          unless installed_packages.include?(pkg_line) then
            return false
          end
        end
      else
        unless setfile.include?("@#{resource[:name]}\n") then
          return false
        end
      end
    end
  end

end
