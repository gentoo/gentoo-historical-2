# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tiff/tiff-3.6.1-r1.ebuild,v 1.11 2004/10/08 09:25:56 eradicator Exp $

inherit eutils

MY_S=${P/tiff-/tiff-v}
MY_P=${PN}-v${PV/_beta/-beta}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Library for manipulation of TIFF (Tag Image File Format) images."
HOMEPAGE="http://www.libtiff.org/"
SRC_URI="ftp://ftp.remotesensing.org/pub/libtiff/${MY_P}.tar.gz
	ftp://ftp.remotesensing.org/libtiff/libtiff-lzw-compression-kit-1.5.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc mips alpha arm hppa amd64 ia64 s390 macos ppc-macos"
IUSE="lzw-tiff"

DEPEND=">=media-libs/jpeg-6b
	>=sys-libs/zlib-1.1.3-r2"

src_unpack() {
	unpack ${MY_P}.tar.gz
	if use lzw-tiff ; then
		ewarn "Applying lzw-compression toolkit..."
		unpack  libtiff-lzw-compression-kit-1.5.tar.gz || die "lzw unpack failed"
		cd libtiff-lzw-compression-kit-1.5/
		cp -f tif_lzw.c ${S}/libtiff/.
		cp README-LZW-COMPRESSION ${S}/.
	fi
	cd ${S}
	cp ${FILESDIR}/config.site-3.6.1-r1 config.site
	echo "DIR_HTML=\"/usr/share/doc/${PF}/html\"" >> config.site
	echo "DIR_LIB=\"/usr/$(get_libdir)\"" >> config.site
	echo "DIR_JPEGLIB=\"/usr/$(get_libdir)\"" >> config.site
	echo "DIR_GZLIB=\"/usr/$(get_libdir)\"" >> config.site

	epatch ${FILESDIR}/${PF}-man.so.patch || die "man.so patch failed"
}

src_compile() {
	OPTIMIZER="${CFLAGS}" ./configure --noninteractive || die
	emake || die
}

src_install() {
	dodir /usr/{bin,$(get_libdir),share/man,share/doc/}
	dodir /usr/share/doc/${PF}/html
	make DESTDIR="${D}" ROOT="" INSTALL="/bin/sh ${S}/port/install.sh" install || die
	preplib /usr
	dodoc README TODO VERSION README-LZW-COMPRESSION
}

pkg_postinst() {
	einfo "The LZW Compression Toolkit is now an optional component"
	einfo "of libtiff.  Add USE="lzw-tiff" to the emerge command to enable."
	ewarn "And don't forget to see README-LZW-COMPRESSION for license info."
}
