# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gzip/gzip-1.3.3.ebuild,v 1.2 2002/10/19 22:01:28 mjc Exp $

IUSE="nls build"

S=${WORKDIR}/${P}
DESCRIPTION="Standard GNU compressor"
SRC_URI="http://www.gzip.org/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/gzip/gzip.html"
# unstable profile for now
KEYWORDS="~x86 ~ppc ~sparc ~sparc64 ~alpha"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc nls? ( sys-devel/gettext )"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}
	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff || die
}

src_compile() {
	[ -z "`use nls`" ] && myconf="--disable-nls"

	# Compiling with gcc3 and higher level of optimization seems to
	# cause a segmentation fault in some very rare cases on alpha. 
	[ ${ARCH} == "alpha" ] && CFLAGS="-O -pipe"
	
	./configure --host=${CHOST} \
		--prefix=/usr \
		--exec-prefix=/ \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		${myconf} || die
	emake || die
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	make prefix=${D}/usr \
		exec_prefix=${D}/ \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	cd ${D}/bin
	for i in gzexe zforce zgrep zmore znew zcmp
	do
		dosed -e "1d" -e "s:${D}::" ${i}
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
