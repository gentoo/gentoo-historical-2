# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/textutils/textutils-2.0.19-r2.ebuild,v 1.1 2002/07/21 16:14:37 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Standard GNU text utilities"
SRC_URI="http://fetish.sf.net/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/textutils/"

KEYWORDS="x86 ppc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc nls?
	( sys-devel/gettext )"
RDEPEND="virtual/glibc"


src_unpack() {
	unpack ${P}.tar.gz
	
	cd ${S}
	# patch to remove Stallman's su rant
	patch doc/coreutils.texi ${FILESDIR}/${P}-gentoo.diff || die
	rm doc/coreutils.info
}


src_compile() {
	local myconf=""
	[ -z "`use nls`" ] && myconf="--disable-nls"
	
	./configure --host=${CHOST} \
		--build=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--without-included-regex \
		${myconf} || die
		
	if [ "`use static`" ]
	then
		emake LDFLAGS=-static || die
	else
		emake || die
	fi
}

src_install() {
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
		
	dodir /bin
	mv ${D}/usr/bin/cat ${D}/bin
	dosym /bin/cat /usr/bin/cat
	# For baselayout
	mv ${D}/usr/bin/wc ${D}/bin
	dosym /bin/wc /usr/bin/wc
	
	rmdir ${D}/usr/lib
	
	if [ -z "`use build`" ]
	then
		dodoc AUTHORS COPYING ChangeLog NEWS README* THANKS TODO
	else
		rm -rf ${D}/usr/share
	fi
}

