# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/radare/radare-1.5-r2.ebuild,v 1.1 2011/02/23 16:00:09 signals Exp $

EAPI="3"
inherit base eutils

DESCRIPTION="Advanced command line hexadecimail editor and more"
HOMEPAGE="http://www.radare.org"
SRC_URI="http://www.radare.org/get/radare-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gui lua readline"

RDEPEND="
	dev-lang/python
	dev-lang/perl
	gui? (
		x11-libs/gtk+:2
		x11-libs/vte )
	lua? ( dev-lang/lua )
	readline? ( sys-libs/readline )
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	gui? ( >=dev-lang/vala-0.5:0 )
"

src_prepare() {
	base_src_prepare
	epatch "${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-more-ldflags.patch \
	# fix documentation installation
	sed -i "s:doc/${PN}:doc/${PF}:g" \
		Makefile.acr global.h.acr src/Makefile.acr wscript dist/maemo/Makefile
}

src_configure() {
	econf \
		$(use_with readline) \
		$(use_with gui)
}

src_compile() {
	emake -j1 || die "compile failed"
}

src_install() {
	emake DESTDIR="${ED}" install || die "install failed"
}
