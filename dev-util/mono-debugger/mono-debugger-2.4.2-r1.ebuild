# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mono-debugger/mono-debugger-2.4.2-r1.ebuild,v 1.1 2009/07/27 22:16:02 flameeyes Exp $

EAPI=2

PATCHLEVEL=1

inherit go-mono mono autotools flag-o-matic eutils

DESCRIPTION="Debugger for .NET managed and unmanaged applications"
HOMEPAGE="http://www.go-mono.com"
SRC_URI="${SRC_URI}
	mirror://gentoo/${P}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

# Binutils is needed for libbfd
RDEPEND="!!=dev-lang/mono-2.2
	|| ( sys-freebsd/freebsd-lib >=dev-libs/libedit-20090111 )
	sys-devel/binutils
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	!dev-lang/mercury"

src_prepare() {
	go-mono_src_prepare

	epatch "${WORKDIR}/${P}-patches-${PATCHLEVEL}"/*

	eautoreconf
}

src_configure() {
	# Let's go for extra safety to avoid runtime errors, until
	# upstream applies it.
	append-ldflags -Wl,--no-undefined

	go-mono_src_configure \
		--with-system-libbfd \
		--with-system-libedit \
		--disable-static
}
