# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Exports GNUSTEP_LOCAL_ROOT"
HOMEPAGE="http://www.gentoo.org"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc "
SLOT="0"

src_install() {
	
	# Does anyone use GNUstep ?  Hopefully this will be fixed when
	# someone package GNUstep, otherwise should work just fine.
	insinto /etc/env.d
	doins ${FILESDIR}/10gnustep
}

