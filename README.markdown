Puppet Gentoo Portage Module
============================

Provides Gentoo portage features for Puppet.

Travis Test status: [![Build
Status](https://travis-ci.org/adrienthebo/puppet-portage.png?branch=master)](https://travis-ci.org/adrienthebo/puppet-portage)

Synopsis
--------

### package\_use ###

    package_use { "app-admin/puppet":
      use    => ["flag1", "flag2"],
      target => "puppet-flags",
    }

use\_flags can be either a string or an array of strings.

### package\_keywords ###

    package_keywords { 'app-admin/puppet':
      keywords  => ['~x86', '-hppa'],
      target  => 'puppet',
    }"

keywords can be either a string or an array of strings.

### package\_mask and package\_unmask ###

    package_unmask { '=app-admin/puppet-2.7.3':
      target  => 'puppet',
    }"

    package_mask { 'app-admin/tree':
      target  => 'tree',
    }"

Limitations
-----------

These types and providers are built around the ParsedFile provider and are
subject to the same limitations.

See Also
--------

  * man 5 portage: http://www.linuxmanpages.com/man5/portage.5.php
  * man 5 ebuild: http://www.linuxmanpages.com/man5/ebuild.5.php

Contributors
============

  * Lance Albertson (https://github.com/ramereth)
  * Russell Haering (https://github.com/russellhaering)
  * Adrien Thebo (https://github.com/adrienthebo)
  * Theo Chatzimichos (https://github.com/tampakrap)
  * John-John Tedro (https://github.com/udoprog)


