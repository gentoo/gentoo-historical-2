# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libgeotiff/libgeotiff-1.2.4.ebuild,v 1.4 2008/02/04 16:58:56 nerdboy Exp $

WANT_AUTOCONF="latest"

inherit autotools eutils flag-o-matic

DESCRIPTION="Library for reading TIFF files with embedded tags for geographic (cartographic) information"
HOMEPAGE="http://remotesensing.org/geotiff/geotiff.html"
SRC_URI="ftp://ftp.remotesensing.org/pub/geotiff/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc python"

DEPEND="virtual/libc
	>=media-libs/tiff-3.7.0
	sci-libs/proj
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-soname.patch || die "epatch failed"
	filter-ldflags "-Wl,-O1"
	eautoconf
}

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "emake failed"

	if use doc; then
	    emake dox || die "emake dox failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	exeinto /usr/bin
	doexe bin/makegeo || die "doexe makegeo failed"
	use python && doexe csv/*.py || die "doexe python failed"

	dodoc README
	newdoc csv/README README.csv
	use doc && dohtml docs/api/*
}
