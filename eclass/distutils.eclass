# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author: Jon Nelson <jnelson@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/distutils.eclass,v 1.4 2002/10/25 19:55:52 vapier Exp $
# The distutils eclass is designed to allow easier installation of
# distutils-based python modules, and their incorporation into 
# the Gentoo Linux system.

ECLASS=distutils
INHERITED="$INHERITED $ECLASS"

EXPORT_FUNCTIONS src_compile src_install

newdepend "virtual/python"

distutils_src_compile() {
	python setup.py build || die "compilation failed"
}

distutils_src_install() {
	python setup.py install --root=${D} || die
	dodoc CHANGELOG COPYRIGHT KNOWN_BUGS MAINTAINERS
	dodoc CONTRIBUTORS LICENSE COPYING*
	dodoc Change* MANIFEST* README* ${mydoc}
}
