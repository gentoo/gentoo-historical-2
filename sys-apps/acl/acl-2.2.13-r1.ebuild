# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/acl/acl-2.2.13-r1.ebuild,v 1.6 2003/09/27 01:48:48 darkspecter Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Access control list utilities, libraries and headers"
HOMEPAGE="http://oss.sgi.com/projects/xfs"
SRC_URI="ftp://oss.sgi.com/projects/xfs/download/cmd_tars/${P}.src.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~amd64 ppc ~sparc ~alpha ~hppa ~mips ~arm"

DEPEND="sys-apps/attr
	sys-devel/autoconf"

src_compile() {
	OPTIMIZER="${CFLAGS}"
	DEBUG=-DNDEBUG

	autoconf || die

	./configure \
	    --mandir=/usr/share/man \
	    --prefix=/usr \
	    --libexecdir=/usr/lib \
	    --libdir=/lib

	cp include/builddefs include/builddefs.orig
	sed -e 's:^PKG_\(.*\)_DIR = \(.*\)$:PKG_\1_DIR = ${DESTDIR}\2:' \
	-e 's:-O1::' include/builddefs.orig > include/builddefs || die

	emake || die

}

src_install() {
	make DIST_ROOT=${D} install install-dev install-lib || die
	#einstall DESTDIR=${D} install install-dev install-lib || die

	rm -f ${D}/usr/lib/libacl.so
	rm -f ${D}/lib/*a
	dosym /lib/libacl.so /usr/lib/libacl.so
	dosym /usr/lib/libacl.la /lib/libacl.la
	dosym /usr/lib/libacl.a /lib/libacl.a

	dodir /bin
	mv ${D}/usr/bin/* ${D}/bin/
	rmdir ${D}/usr/bin/
}
