# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc-compat/gcc-compat-1.4.ebuild,v 1.1 2002/09/19 17:40:31 carpaski Exp $

DESCRIPTION="This is a compatability layer for use when upgrading to profile $PV"
HOMEPAGE="http://www.gentoo.org"
SRC_URI=""
LICENSE="gpl-2"

# Only ONE version of this should exist on a system
# This is ABSOLUTELY Machine non-specific
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND=""
RDEPEND=""

# DON'T STRIP THE LIBS!
RESTRICT="nostrip"

src_compile() {
	echo -ne ""
}

src_install () {
	cd /
	tar cvf ${WORKDIR}/gcc-libs.tar $(find /usr/lib/gcc-lib/ -type f -name '*.so*')
	cd ${D}
	tar -mxvf ${WORKDIR}/gcc-libs.tar
}
