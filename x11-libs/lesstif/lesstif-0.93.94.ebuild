# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/lesstif/lesstif-0.93.94.ebuild,v 1.6 2004/08/02 01:41:28 tgall Exp $

inherit libtool

DESCRIPTION="An OSF/Motif(R) clone"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.lesstif.org/"
LICENSE="LGPL-2"
KEYWORDS="x86 ppc sparc amd64 ppc64"
SLOT="0"
IUSE=""
DEPEND="virtual/libc
	virtual/x11"

src_compile() {
	elibtoolize

	econf \
	  --enable-build-12 \
	  --disable-build-20 \
	  --disable-build-21 \
	  --enable-static \
	  --enable-shared \
	  --enable-production \
	  --enable-verbose=no \
	  --with-x || die "./configure failed"

	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	make DESTDIR=${D} install || die "make install"


	einfo "Fixing binaries"
	dodir /usr/X11R6/bin/lesstif
	for file in `ls ${D}/usr/bin`
	do
		mv ${D}/usr/bin/${file} ${D}/usr/X11R6/bin/lesstif/${file}
	done
	rm -f ${D}/usr/X11R6/bin/lesstif/mxmkmf
	rm -fR ${D}/usr/bin


	einfo "Fixing docs"
	dodir /usr/share/doc/
	mv ${D}/usr/LessTif ${D}/usr/share/doc/${P}
	rm -fR ${D}/usr/lib/LessTif


	einfo "Fixing libraries"
	dodir /usr/X11R6/lib/lesstif
	mv ${D}/usr/lib/lib* ${D}/usr/X11R6/lib/lesstif
	cd ${D}/usr/X11R6/lib

	for lib in libMrm.so.1 libMrm.so.1.0.2 \
		libUil.so.1 libUil.so.1.0.2 \
		libXm.so.1  libXm.so.1.0.2
	do
		ln -s "lesstif/${lib}" .
	done
	rm -fR ${D}/usr/lib


	einfo "Fixing includes"
	dodir /usr/X11R6/include/lesstif/
	mv ${D}/usr/include/* ${D}/usr/X11R6/include/lesstif
	rm -fR ${D}/usr/include


	einfo "Fixing man pages"
	dodir /usr/X11R6/share/man/{man1,man3,man5}
	for file in `ls ${D}/usr/share/man/man1`
	do
		file=${file/.1/}
		mv ${D}/usr/share/man/man1/${file}.1 ${D}/usr/X11R6/share/man/man1/${file}-12.1
	done
	for file in `ls ${D}/usr/share/man/man3`
	do
		file=${file/.3/}
		mv ${D}/usr/share/man/man3/${file}.3 ${D}/usr/X11R6/share/man/man3/${file}-12.3
	done
	for file in `ls ${D}/usr/share/man/man6`
	do
		file=${file/.5/}
		mv ${D}/usr/share/man/man5/${file}.5 ${D}/usr/X11R6/share/man/man5/${file}-12.5
	done
	rm -fR ${D}/usr/share/man

	rm -fR ${D}/usr/share/aclocal
}
