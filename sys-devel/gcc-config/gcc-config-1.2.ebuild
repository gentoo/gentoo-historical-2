# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gcc-config/gcc-config-1.2.ebuild,v 1.2 2002/12/09 04:37:27 manson Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="Utility to change the gcc compiler being used."
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"

KEYWORDS="x86 ppc sparc  alpha"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"


src_install() {
	newsbin ${FILESDIR}/${PN}-${PV} ${PN}
}

