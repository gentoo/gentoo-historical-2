# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libircclient/libircclient-1.6-r1.ebuild,v 1.2 2012/09/07 20:22:31 hasufell Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="Small but powerful library implementing the client-server IRC protocol"
HOMEPAGE="http://www.ulduzsoft.com/libircclient/"
SRC_URI="mirror://sourceforge/libircclient/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ipv6 ssl static threads"

DEPEND="ssl? ( dev-libs/openssl )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-shared.patch \
		"${FILESDIR}"/${P}-include.patch
	eautoconf
}

src_configure() {
	econf \
		$(use_enable threads) \
		$(use_enable ipv6) \
		$(use_enable ssl openssl) \
		$(use_enable ssl threads)
}

src_compile() {
	emake -C src $(usex static "shared static" "shared")
}

src_install() {
	emake -C src DESTDIR="${D}" $(usex static "install" "install-headers install-shared")

	dodoc Changelog THANKS
	if use doc ; then
		doman doc/man/man3/*
		dohtml doc/html/*
	fi
}
