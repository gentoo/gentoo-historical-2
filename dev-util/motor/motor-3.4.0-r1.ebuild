# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/motor/motor-3.4.0-r1.ebuild,v 1.2 2006/08/22 22:25:07 wormo Exp $

inherit eutils

DESCRIPTION="text mode based programming environment for Linux"
HOMEPAGE="http://thekonst.net/en/motor"
SRC_URI="http://thekonst.net/download/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ppc"
IUSE="nls"

DEPEND=">=sys-libs/ncurses-5.2
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/motor-3.2.2-security.patch"
}

src_compile() {
	econf `use_enable nls` || die
	emake || die
}

src_install() {
	einstall || die

	dodoc AUTHORS COPYING README TODO FAQ ChangeLog
	docinto tutorial
	dohtml -r tutorial/*
}
