# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/dialog/dialog-0.9_beta20031207.ebuild,v 1.10 2004/08/06 14:44:50 vapier Exp $

inherit eutils

MY_PV="${PV/_beta/b-}"
S=${WORKDIR}/${PN}-${MY_PV}
DESCRIPTION="tool to display dialog boxes from a shell"
HOMEPAGE="http://hightek.org/dialog/"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips alpha arm hppa amd64 ~ia64 ~ppc64 s390 macos"
IUSE=""

DEPEND=">=app-shells/bash-2.04-r3
	>=sys-libs/ncurses-5.2-r5"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-estonian-sed.patch
}

src_compile() {
	econf --with-ncurses || die "configure failed"
	emake || die "build failed"
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc CHANGES README VERSION
}
