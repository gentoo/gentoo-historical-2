# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-giFT/gkrellm-giFT-0.2.2.ebuild,v 1.3 2004/06/12 18:21:17 pyrania Exp $

inherit eutils

MY_PN=${PN/FT/ft}
MY_P=${MY_PN}-${PV}
DESCRIPTION="GKrellM2 plugin to monitor giFT transfers"
SRC_URI="ftp://ftp.code-monkey.de/pub/${MY_PN}/${P}.tar.gz"
HOMEPAGE="http://www.code-monkey.de/gkrellm-gift.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=app-admin/gkrellm-2.1.23
	>=net-p2p/gift-0.11.3"

src_unpack() {
	unpack ${A}

	if has_version ">=x11-libs/gtk+-2.4"
	then
		epatch ${FILESDIR}/${MY_P}.patch
	fi
}

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING FAQ README
}
