# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tiff/tiff-3.8.2-r8.ebuild,v 1.4 2009/07/19 16:13:53 nixnut Exp $

EAPI=2

inherit eutils libtool

DESCRIPTION="Library for manipulation of TIFF (Tag Image File Format) images"
HOMEPAGE="http://www.remotesensing.org/libtiff/"
SRC_URI="ftp://ftp.remotesensing.org/pub/libtiff/${P}.tar.gz
	mirror://gentoo/${P}-pdfsec-patches.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 m68k ~mips ppc ~ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="jpeg jbig nocxx zlib"

RDEPEND="jpeg? ( >=media-libs/jpeg-6b )
	jbig? ( >=media-libs/jbigkit-1.6-r1 )
	zlib? ( >=sys-libs/zlib-1.1.3-r2 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${WORKDIR}"/${P}-tiff2pdf-20080903.patch
	epatch "${FILESDIR}"/${P}-tiffsplit.patch
	if use jbig; then
		epatch "${FILESDIR}"/${PN}-jbig.patch
	fi
	epatch "${WORKDIR}"/${P}-goo-sec.patch
	epatch "${FILESDIR}"/${P}-CVE-2008-2327.patch
	epatch "${FILESDIR}"/${P}-CVE-2009-2285.patch
	epatch "${FILESDIR}"/${P}-CVE-2009-2347.patch
	elibtoolize
}

src_configure() {
	econf \
		$(use_enable !nocxx cxx) \
		$(use_enable zlib) \
		$(use_enable jpeg) \
		$(use_enable jbig) \
		--with-pic --without-x \
		--with-docdir=/usr/share/doc/${PF}
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed"
	dodoc README TODO VERSION
}

pkg_postinst() {
	if use jbig; then
		echo
		elog "JBIG support is intended for Hylafax fax compression, so we"
		elog "really need more feedback in other areas (most testing has"
		elog "been done with fax).  Be sure to recompile anything linked"
		elog "against tiff if you rebuild it with jbig support."
		echo
	fi
}
