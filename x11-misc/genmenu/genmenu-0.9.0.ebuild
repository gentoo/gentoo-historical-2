# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 
# $Header: /var/cvsroot/gentoo-x86/x11-misc/genmenu/genmenu-0.9.0.ebuild,v 1.1 2002/10/27 07:39:05 george Exp $

S="${WORKDIR}/${P}"

DESCRIPTION="menu generator for Blackbox, WindowMaker, and Enlightenment"
SRC_URI="http://home.online.no/~geir37/archive/${P}.tar.gz"
HOMEPAGE="http://projects.gtk.mine.nu/genmenu"

LICENSE="GPL-2"
DEPEND="sys-apps/bash"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch genmenu < ${FILESDIR}/${PN}-${PV}.patch
}

src_install () {
	dobin genmenu
	
	# Install documentation.
	dodoc ChangeLog README
}
