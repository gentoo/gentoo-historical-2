# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/jpeg/jpeg-6b-r7.ebuild,v 1.14 2006/06/25 06:28:20 vapier Exp $

inherit libtool eutils toolchain-funcs

PATCH_VER=1.4
DESCRIPTION="Library to load, handle and manipulate images in the JPEG format"
HOMEPAGE="http://www.ijg.org/"
SRC_URI="ftp://ftp.uu.net/graphics/jpeg/${PN}src.v${PV}.tar.gz
	mirror://gentoo/${P}-patches-${PATCH_VER}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc-macos ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-devel/libtool-1.5.10-r4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	elibtoolize
}

src_compile() {
	tc-export CC RANLIB AR

	econf --enable-shared --enable-static \
		--enable-maxmem=64 || die "econf failed"
	emake || die "make failed"
	emake -C "${WORKDIR}"/extra || die "make extra failed"
}

src_install() {
	make install DESTDIR="${D}" || die "install"
	make -C "${WORKDIR}"/extra install DESTDIR="${D}" || die "install extra"

	dodoc README install.doc usage.doc wizard.doc change.log \
		libjpeg.doc example.c structure.doc filelist.doc \
		coderules.doc
}
