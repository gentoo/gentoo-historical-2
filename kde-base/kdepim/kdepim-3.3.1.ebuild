# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim/kdepim-3.3.1.ebuild,v 1.4 2004/10/21 20:15:12 pvdabeel Exp $

inherit kde-dist eutils

DESCRIPTION="KDE PIM (Personal Information Management) apps: korganizer, kmail, knode..."

KEYWORDS="~amd64 ~hppa ~sparc ~x86 ~ppc"
IUSE="crypt gnokii pda"

DEPEND=">=kde-base/kdebase-3.3.0
	pda? ( app-pda/pilot-link dev-libs/libmal )
	gnokii? ( net-dialup/gnokii )
	crypt? ( >=app-crypt/gpgme-0.9.0-r1 )"
