# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/nomad-tool/nomad-tool-1.3.ebuild,v 1.1.1.1 2005/11/30 10:06:04 chriswhite Exp $

DESCRIPTION="Controls the Nomad II MG and IIc portable MP3 players"
HOMEPAGE="http://www.swiss.ai.mit.edu/~cph/nomad.ssp"
SRC_URI="http://www.swiss.ai.mit.edu/~cph/nomad/${P}.tar.gz"

SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
}

src_compile() {
	cd ${WORKDIR}
	make PREFIX="/usr" || die "compile failed"
}

src_install() {
	cd ${WORKDIR}
	dobin nomad-tool
	dolib nomad-open
	doman nomad-tool.1
}

pkg_postinst() {
	chmod 4755 /usr/lib/nomad-open
}
