# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/dialog/dialog-0.9_beta20031002.ebuild,v 1.1 2003/10/05 14:53:33 hillster Exp $

MY_PV="${PV/_beta/b-}"
S=${WORKDIR}/${PN}-${MY_PV}
DESCRIPTION="A Tool to display Dialog boxes from Shell"
SRC_URI="ftp://ftp.debian.org/debian/pool/main/d/${PN}/${PN}_${MY_PV}.orig.tar.gz"
HOMEPAGE="http://hightek.org/dialog/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha hppa ~arm ~amd64"

DEPEND=">=app-shells/bash-2.04-r3
	>=sys-libs/ncurses-5.2-r5"

src_compile() {
	econf --with-ncurses || die "configure failed"
}

src_install() {
	einstall MANDIR=${D}/usr/share/man/man1 || die

	dodoc CHANGES COPYING README VERSION
}
