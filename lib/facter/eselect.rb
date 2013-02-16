eselect_modules = %x(eselect modules list).split("  ").reject! { |c| c.empty? }
eselect_modules = eselect_modules.delete_if { |c| c["\n"] }
eselect_modules_blacklist = [
  "help", "usage", "version", "bashcomp", "env", "fontconfig", "modules",
  "news", "rc",
]
eselect_modules = eselect_modules - eselect_modules_blacklist

eselect_modules.each do |eselect_module|
  Facter.add("eselect_#{eselect_module}") do
    confine :operatingsystem => :gentoo
    setcode do
      %x{eselect --brief --no-color #{eselect_module} show}.strip.split(' ')[0]
    end
  end
end
