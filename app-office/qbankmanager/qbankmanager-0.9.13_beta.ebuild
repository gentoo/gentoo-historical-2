# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/qbankmanager/qbankmanager-0.9.13_beta.ebuild,v 1.1 2005/01/14 04:36:40 hanno Exp $

inherit eutils kde-functions
need-qt 3

DESCRIPTION="Onlinebanking frontend for aqbanking"
HOMEPAGE="http://www.aquamaniacs.de/aqbanking/"
SRC_URI="mirror://sourceforge/aqbanking/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=">=net-libs/aqbanking-0.9.9
	>=x11-libs/qt-3
	net-libs/aqhbci-qt-wizard"

S=${WORKDIR}/${P/_/}

src_compile() {
	econf `use_enable debug` || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS README TODO README COPYING NEWS
}
