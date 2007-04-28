# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/welcome2l/welcome2l-3.04.ebuild,v 1.14 2007/04/28 19:19:47 tove Exp $

inherit eutils

MY_PN=Welcome2L
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Welcome to Linux, ANSI login logo for Linux"
HOMEPAGE="http://www.littleigloo.org/"
SRC_URI="http://www.chez.com/littleigloo/files/${MY_P}.src.tar.gz
	mirror://gentoo/${P}-gentoo.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${P}-gentoo.patch
}

src_compile() {
	make || die
}

src_install() {
	dobin ${MY_PN}
	doman ${MY_PN}.1
	dodoc AUTHORS README INSTALL ChangeLog BUGS TODO
	newinitd "${FILESDIR}"/${PN}.initscript ${MY_PN}
}

pkg_postinst() {
	elog "NOTE: To start Welcome2L on boot, please type:"
	elog "rc-update add Welcome2L default"
}
