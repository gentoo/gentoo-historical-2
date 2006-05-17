# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cfitsio/cfitsio-3.006.ebuild,v 1.1 2006/05/17 06:20:53 nerdboy Exp $

inherit eutils multilib toolchain-funcs

IUSE="doc"

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${PN}${PV//.}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

DEPEND="virtual/libc"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-makefile.patch || die "epatch failed"
}

src_compile() {
	econf --host=${CHOST} --prefix=${D}usr --libdir=${D}usr/$(get_libdir) || die "econf failed"
	make || die "make failed"
	make shared fitscopy imcopy listhead
}

src_install () {
	dodir /usr/bin /usr/include /usr/$(get_libdir)
	dolib.so libcfitsio.so.*
	dobin fitscopy imcopy listhead
	dodoc changes.txt README

	if use doc; then
		dodoc *.ps cookbook.*
	fi

	insinto /usr/include
	doins fitsio.h fitsio2.h longnam.h drvrsmem.h
}
