require 'facter/util/portage'

if Facter.value(:operatingsystem) == 'Gentoo'
  Facter::Util::Portage.emerge_info.each_pair do |name, value|
    Facter.add("emerge_#{name}") do setcode { value }; end
  end
end
