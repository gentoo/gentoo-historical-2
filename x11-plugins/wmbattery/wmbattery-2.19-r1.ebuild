# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmbattery/wmbattery-2.19-r1.ebuild,v 1.1 2004/07/16 23:09:32 s4t4n Exp $

inherit eutils

IUSE=""

S=${WORKDIR}/${PN}

DESCRIPTION="A dockable app to report APM battery stats."
SRC_URI="http://kitenet.net/programs/wmbattery/${P/-/_}.tar.gz"
HOMEPAGE="http://kitenet.net/programs/wmbattery"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 amd64"

DEPEND="virtual/x11
	sys-apps/apmd"

src_compile() {
	econf || die "Configuration failed"
	emake icondir="/usr/share/pixmaps/wmbattery" || die "Compilation failed"
}

src_install () {
	dobin wmbattery
	dodoc README COPYING TODO

	mv wmbattery.1x wmbattery.1
	doman wmbattery.1

	insinto /usr/share/pixmaps/wmbattery
	doins *.xpm
}
