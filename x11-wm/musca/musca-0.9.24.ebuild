# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/musca/musca-0.9.24.ebuild,v 1.2 2009/11/04 10:27:31 jer Exp $

EAPI="2"

inherit eutils savedconfig toolchain-funcs

DESCRIPTION="A simple dynamic window manager for X, with features nicked from
ratpoison and dwm"
HOMEPAGE="http://aerosuidae.net/musca/"
SRC_URI="http://aerosuidae.net/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE="apis"

COMMON="x11-libs/libX11"
DEPEND="${COMMON} sys-apps/sed"
RDEPEND="
	${COMMON} x11-misc/dmenu
	apis? ( x11-misc/xbindkeys )
"

src_prepare() {
	sed -e 's|$(CFLAGS)|& $(LDFLAGS)|g' -i Makefile
	use apis || sed -e '/apis/d' -i Makefile
	use savedconfig && restore_config config.h
}

src_compile() {
	use savedconfig && msg=", please check the saved config file"
	tc-export CC
	emake || die "emake failed${msg}"
}

src_install() {
	dobin musca xlisten || die "dobin failed"
	if use apis; then
		dobin apis || die "dobin failed"
	fi
	doman musca.1 || die "doman failed"
	save_config config.h
}
