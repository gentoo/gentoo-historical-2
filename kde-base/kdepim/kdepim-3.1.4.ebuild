# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim/kdepim-3.1.4.ebuild,v 1.5 2003/11/20 02:45:11 lu_zero Exp $
inherit kde-dist

IUSE="pda"
DESCRIPTION="KDE PIM (Personal Information Management) apps: korganizer..."
KEYWORDS="x86 ppc sparc ~amd64"

newdepend "pda? ( >=app-pda/pilot-link-0.11.1-r1
				>=dev-libs/libmal-0.31 )
	dev-lang/perl
	=kde-base/kdebase-${PV}*
	~kde-base/kdenetwork-${PV}" # mimelib is needed for support of some stuff with exchange servers

use pda && myconf="$myconf --with-extra-includes=/usr/include/libpisock"

# reported by doctomoe on ppc
MAKEOPTS="$MAKEOPTS -j1"

src_unpack() {
	kde_src_unpack
	#epatch ${FILESDIR}/${P}-gcc33.diff
}

src_install() {
	kde_src_install
	docinto html
	dodoc *.html
}
