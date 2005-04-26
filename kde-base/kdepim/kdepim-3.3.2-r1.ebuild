# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim/kdepim-3.3.2-r1.ebuild,v 1.1 2005/04/26 16:01:07 carlo Exp $

inherit kde-dist eutils

DESCRIPTION="KDE PIM (Personal Information Management) apps: korganizer, kmail, knode..."

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~mips"
IUSE="crypt gnokii pda cjk"

DEPEND=">=kde-base/kdebase-3.3.0
	pda? ( app-pda/pilot-link dev-libs/libmal )
	gnokii? ( net-dialup/gnokii )
	crypt? ( >=app-crypt/gpgme-0.9.0-r1 )"

src_unpack() {
	kde_src_unpack
	cd ${S}
	epatch ${FILESDIR}/kdepim-3.3.2-kmail-imap-preview.diff
	use cjk && epatch ${FILESDIR}/kdepim-3.2.3-cjk.diff
}
