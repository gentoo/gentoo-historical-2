# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim/kdepim-3.3.0.ebuild,v 1.12 2004/12/02 12:21:22 dragonheart Exp $

inherit kde-dist eutils

DESCRIPTION="KDE PIM (Personal Information Management) apps: korganizer, kmail, knode..."

KEYWORDS="amd64"
IUSE="pda crypt cjk"

DEPEND="pda? ( app-pda/pilot-link dev-libs/libmal )
		crypt? ( >=app-crypt/gpgme-0.9.0-r1 )"

src_unpack() {
	kde_src_unpack
	epatch ${FILESDIR}/kdepim-3.3.0-korganizer.patch
	use cjk && epatch ${FILESDIR}/kdepim-3.2.3-cjk.diff
}

src_compile() {
	kde_src_compile
}
