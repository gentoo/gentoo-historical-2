# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libdap/libdap-3.9.2.ebuild,v 1.5 2009/07/18 18:53:12 nerdboy Exp $

inherit autotools eutils flag-o-matic

DESCRIPTION="A C++ SDK which contains an implementation of DAP 2.0 and 3.2, both Client- and Server-side support."
HOMEPAGE="http://opendap.org/index.html"
SRC_URI="http://www.opendap.org/pub/source/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 URI )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc"

RDEPEND="dev-util/cppunit
	dev-util/dejagnu"

DEPEND="${RDEPEND}
	>=sys-libs/zlib-1.1.4
	>=dev-libs/libxml2-2.5.7
	>=net-misc/curl-7.12.0
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eaclocal
	eautoreconf

	epatch "${FILESDIR}"/${P}-gcc-4.4.patch
}

src_compile() {
	local myconf="--disable-dependency-tracking"
	econf ${myconf} || die "econf failed"
	emake -j1 || die "emake failed"

	if use doc; then
	    make docs || die "make docs failed"
	fi
}

src_test() {
	cd "${S}"/unit-tests && make check
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc README NEWS README.dodsrc README.AIS
	use doc && dohtml docs/html/*
}
