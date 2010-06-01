# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libasyncns/libasyncns-0.8.ebuild,v 1.1 2010/06/01 20:43:06 darkside Exp $

EAPI=3
inherit libtool flag-o-matic

DESCRIPTION="C library for executing name service queries asynchronously."
HOMEPAGE="http://0pointer.de/lennart/projects/libasyncns/"
SRC_URI="http://0pointer.de/lennart/projects/libasyncns/${P}.tar.gz"

SLOT="0"

LICENSE="LGPL-2.1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-linux"

IUSE="doc debug"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	elibtoolize
}

src_configure() {
	# libasyncns uses assert()
	use debug || append-flags -DNDEBUG

	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--disable-dependency-tracking \
		--disable-lynx
}

src_compile() {
	emake || die "emake failed"

	if use doc; then
		doxygen doxygen/doxygen.conf || die "doxygen failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc; then
		docinto apidocs
		dohtml html/*
	fi
}
