# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim/kdepim-3.1.ebuild,v 1.6 2003/02/12 17:43:26 hannes Exp $
inherit kde-dist 

IUSE="pda"
DESCRIPTION="KDE PIM (Personal Information Management) apps: korganizer..."
KEYWORDS="x86 ppc ~sparc"

newdepend "pda? ( >=dev-libs/pilot-link-0.11.1-r1 )
	sys-devel/perl
	~kde-base/kdebase-$PV
	~kde-base/kdenetwork-$PV" # mimelib is needed for support of some stuff with exchange servers

use pda && myconf="$myconf --with-extra-includes=/usr/include/libpisock"

# reported by doctomoe on ppc
MAKEOPTS="$MAKEOPTS -j1"

src_install() {
	kde_src_install
	docinto html
	dodoc *.html
}
