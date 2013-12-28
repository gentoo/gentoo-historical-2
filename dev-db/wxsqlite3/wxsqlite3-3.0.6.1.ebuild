# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/wxsqlite3/wxsqlite3-3.0.6.1.ebuild,v 1.2 2013/12/28 21:25:23 jlec Exp $

EAPI=5

WX_GTK_VER="2.8"

inherit eutils multilib wxwidgets

DESCRIPTION="C++ wrapper around the public domain SQLite 3.x database"
HOMEPAGE="http://wxcode.sourceforge.net/components/wxsqlite3/"
SRC_URI="mirror://sourceforge/wxcode/${P}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unicode"

DEPEND="
	x11-libs/wxGTK:2.8[X]
	dev-db/sqlite:3"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P%.1}"

src_prepare() {
	rm -rf sqlite3 || die
	cp configure28 configure || die
	sed \
		-e "s:@WXVERSION@:${WX_GTK_VER}:g" \
		-e "s:@LIBDIR@:$(get_libdir):g" \
		-e "s:@VERSION@:${PV}:g" \
		"${FILESDIR}"/${P}.pc.in > ${PN}.pc || die
}

src_configure() {
	econf \
		$(use_enable unicode) \
		--enable-shared \
		--with-wx-config="${WX_CONFIG}" \
		--with-wxshared \
		--with-sqlite3-prefix="${PREFIX}/usr"
}

src_install() {
	default

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	dodoc Readme.txt
	dohtml -r docs/html/*
	docinto samples
	dodoc -r samples/*
}
