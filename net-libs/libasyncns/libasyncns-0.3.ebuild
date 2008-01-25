# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libasyncns/libasyncns-0.3.ebuild,v 1.8 2008/01/25 19:07:02 corsair Exp $

inherit libtool autotools

DESCRIPTION="C library for executing name service queries asynchronously."
HOMEPAGE="http://0pointer.de/lennart/projects/libasyncns/"
SRC_URI="http://0pointer.de/lennart/projects/libasyncns/${P}.tar.gz"

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~hppa ia64 ppc64 sparc x86"

IUSE="doc debug"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}

	cd "${S}"

	sed -i -e 's:noinst:check:' "${S}/${PN}/Makefile.am" \
		|| die "unable to fix the Makefile"

	eautoreconf
	elibtoolize
}

src_compile() {
	# libasyncns uses assert()
	use debug || append-flags -DNDEBUG

	econf \
		--disable-dependency-tracking \
		--disable-lynx \
		|| die "econf failed"
	emake || die "emake failed"

	if use doc; then
		doxygen doxygen/doxygen.conf || die "doxygen failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc doc/README
	dohtml doc/README.html doc/styles.css

	if use doc; then
		docinto apidocs
		dohtml html/*
	fi
}
