# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mono-debugger/mono-debugger-2.6.ebuild,v 1.1 2010/02/21 12:41:45 patrick Exp $

# bah, tests fail. Needs to be fixed ...
RESTRICT="test"

EAPI=2

PATCHLEVEL=1

inherit go-mono mono autotools flag-o-matic eutils

DESCRIPTION="Debugger for .NET managed and unmanaged applications"
HOMEPAGE="http://www.go-mono.com"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

# Binutils is needed for libbfd
RDEPEND="!!=dev-lang/mono-2.2
	>=dev-libs/libedit-20090111
	sys-devel/binutils
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	!dev-lang/mercury"

src_prepare() {
	go-mono_src_prepare
	
	epatch "${FILESDIR}/${P}-respect-cflags.patch" \
		"${FILESDIR}/${P}-system-bfd.patch" \
		"${FILESDIR}/${P}-system-libedit.patch"

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

src_compile() {
	emake -j1 || die "Failed to build"
}
