# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/dialog/dialog-0.9_beta20031207.ebuild,v 1.5 2004/04/17 07:25:35 lv Exp $

inherit eutils

MY_PV="${PV/_beta/b-}"
S=${WORKDIR}/${PN}-${MY_PV}
DESCRIPTION="A Tool to display Dialog boxes from Shell"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${MY_PV}.orig.tar.gz"
HOMEPAGE="http://hightek.org/dialog/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~mips amd64 ~ia64 ~ppc64 s390"

DEPEND=">=app-shells/bash-2.04-r3
	>=sys-libs/ncurses-5.2-r5"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-estonian-sed.patch
}

src_compile() {
	econf --with-ncurses || die "configure failed"
}

src_install() {
	einstall MANDIR=${D}/usr/share/man/man1 || die

	dodoc CHANGES COPYING README VERSION
}
