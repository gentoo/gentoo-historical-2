# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>, Chad Huneycutt <chad.huneycutt@acm.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gzip/gzip-1.3.2.ebuild,v 1.1 2001/12/17 17:25:01 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Standard GNU compressor"
SRC_URI="ftp://alpha.gnu.org/gnu/gzip/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/gzip/gzip.html"

DEPEND="virtual/glibc nls? ( sys-devel/gettext )"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff || die
}

src_compile() {
	[ -z "`use nls`" ] && myconf="--disable-nls"
	./configure --host=${CHOST} --prefix=/usr --exec-prefix=/ --mandir=/usr/share/man --infodir=/usr/share/info ${myconf} || die
	emake || die
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	make prefix=${D}/usr exec_prefix=${D}/ mandir=${D}/usr/share/man infodir=${D}/usr/share/info install || die
	cd ${D}/bin
	for i in gzexe zforce zgrep zmore znew zcmp
	do
	cp ${i} ${i}.orig
		sed -e "1d" -e "s:${D}::" ${i}.orig > ${i}
		rm ${i}.orig
		chmod 755 ${i}
	done
	if [ -z "`use build`" ]
	then
		cd ${D}/usr/share/man/man1
		rm -f gunzip.* zcmp.* zcat.*
		ln -s gzip.1.gz gunzip.1.gz
		ln -s zdiff.1.gz zcmp.1.gz
		ln -s gzip.1.gz zcat.1.gz
		cd ${S}
		rm -rf ${D}/usr/man ${D}/usr/lib
		dodoc ChangeLog COPYING NEWS README THANKS TODO
		docinto txt
		dodoc algorithm.doc gzip.doc
	else
		rm -rf ${D}/usr
	fi
}




