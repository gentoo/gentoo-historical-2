# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/cutecom/cutecom-0.12.0.ebuild,v 1.2 2005/07/25 15:58:42 caleb Exp $

inherit eutils qt3

DESCRIPTION="CuteCom is a serial terminal, like minicom, written in qt"
HOMEPAGE="http://cutecom.sourceforge.net"
SRC_URI="http://cutecom.sourceforge.net/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE=""
DEPEND="$(qt_min_version 3.2)"

src_compile() {
	addwrite "${QTDIR}/etc/settings"
	econf
	emake
}

src_install() {
	dobin "cutecom"
	dodoc README Changelog COPYING README

	make_desktop_entry cutecom "CuteCom" openterm
}
