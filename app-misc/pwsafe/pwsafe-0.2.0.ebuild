# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pwsafe/pwsafe-0.2.0.ebuild,v 1.1 2007/07/08 18:59:11 taviso Exp $

inherit eutils

DESCRIPTION="Password Safe Compatible Commandline Password Manager"
HOMEPAGE="http://nsd.dyndns.org/pwsafe/"
SRC_URI="http://nsd.dyndns.org/pwsafe/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="X readline"

DEPEND="sys-libs/ncurses
		dev-libs/openssl
		readline? ( sys-libs/readline )
		X? ( || ( (
					x11-libs/libSM
					x11-libs/libICE
					x11-libs/libXmu 
					x11-libs/libX11
				)
				virtual/x11 
			)
		)"
RDEPEND="${DEPEND}"

src_compile() {
	econf $(use_with X x) $(use_with readline)
	emake
}

src_install() {
	doman pwsafe.1
	dobin pwsafe
	dodoc README NEWS
}
