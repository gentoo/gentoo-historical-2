# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/file/file-3.39.ebuild,v 1.7 2003/02/08 22:27:20 tuxus Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Program to identify a file's format by scanning binary data for patterns"
SRC_URI="ftp://ftp.gw.com/mirrors/pub/unix/file/${P}.tar.gz
	ftp://ftp.astron.com/pub/file/${P}.tar.gz"
HOMEPAGE="ftp://ftp.astron.com/pub/file/"

KEYWORDS="x86 ppc sparc alpha mips"
SLOT="0"
LICENSE="as-is"

DEPEND="virtual/glibc"

src_unpack() {
    unpack ${A}

    if [ "${ARCH}" = "mips" ]
            then
    cd ${S}
    patch -p1 < ${FILESDIR}/${P}-gentoo.diff || die
    fi
}

src_compile() {
	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--datadir=/usr/share/misc \
		--host=${CHOST} || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	if [ -z "`use build`" ] ; then
		dodoc LEGAL.NOTICE MAINT README
	else
		rm -rf ${D}/usr/share/man
	fi
}
