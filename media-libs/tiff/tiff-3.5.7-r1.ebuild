# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tiff/tiff-3.5.7-r1.ebuild,v 1.9 2003/02/12 18:11:33 gmsoft Exp $

MY_P=${P/tiff-/tiff-v}
S=${WORKDIR}/${MY_P}
DESCRIPTION="libtiff"
SRC_URI="ftp://ftp.remotesensing.org/pub/libtiff/${MY_P}.tar.gz"
HOMEPAGE="http://www.libtiff.org/"

DEPEND=">=media-libs/jpeg-6b 
	>=sys-libs/zlib-1.1.3-r2"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc alpha hppa"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp ${FILESDIR}/config.site config.site
	echo "DIR_HTML="${D}/usr/share/doc/${PF}/html"" >> config.site
}

src_compile() {
	OPTIMIZER="${CFLAGS}" ./configure --noninteractive || die
	emake || die
}

src_install() {
	dodir /usr/{bin,lib,share/man,share/doc/${PF}/html}
	dodir /usr/share/doc/${PF}/html
	make INSTALL="/bin/sh ${S}/port/install.sh" install || die
	preplib /usr
	dodoc COPYRIGHT README TODO VERSION
}
