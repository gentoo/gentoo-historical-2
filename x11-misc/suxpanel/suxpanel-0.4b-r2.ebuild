# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/suxpanel/suxpanel-0.4b-r2.ebuild,v 1.1 2010/06/06 12:54:58 ssuominen Exp $

EAPI=2
inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="SuxPanel is a complete rewrite of MacOS Style Panel, a light-weight X11 desktop panel"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"
HOMEPAGE="http://suxpanel.berlios.de"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	x11-libs/libwnck"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.in.patch \
		"${FILESDIR}"/${P}-stdlib.patch

	sed -i \
		-e "s:share/${PN}/plugins:$(get_libdir)/${PN}/plugins:" \
		Makefile.in suxpanel-install.sh || die
}

src_configure() {
	use amd64 && append-flags -O0
	tc-export CC
	econf
}

src_install () {
	emake DESTDIR="${D}" install || die
	dobin suxpanel-install.sh || die
	dodoc README
}
