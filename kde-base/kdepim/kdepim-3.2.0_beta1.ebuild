# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim/kdepim-3.2.0_beta1.ebuild,v 1.3 2003/11/08 12:27:12 caleb Exp $
inherit kde-dist

IUSE="pda crypt"
DESCRIPTION="KDE PIM (Personal Information Management) apps: korganizer, kmail, knode..."
KEYWORDS="~x86"

newdepend "pda? ( >=app-pda/pilot-link-0.11.1-r1 >=dev-libs/libmal-0.31 )
	crypt? ( app-crypt/cryptplug )
	dev-lang/perl
	=kde-base/kdebase-${PV}
	~kde-base/kdenetwork-${PV}" # mimelib is needed for support of some stuff with exchange servers

use pda && myconf="$myconf --with-extra-includes=/usr/include/libpisock"

src_install() {
	kde_src_install
	docinto html
	dodoc *.html
}
