# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/powertweak/powertweak-0.1.17-r2.ebuild,v 1.5 2002/10/04 03:44:41 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Powertweak"
SRC_URI="http://powertweak.sourceforge.net/files/${P}.tar.bz2"
HOMEPAGE="http://powertweak.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -ppc"

DEPEND="=x11-libs/gtk+-1.2*
	>=dev-libs/libxml-1.8.10"

src_unpack() {

	CFLAGS="${CPPFLAGS} -Wno-error"
	CPPFLAGS="${CPPFLAGS} -Wno-deprecated"
	unpack ${A}
	cd ${S}
	for FILE in `find . -iname "Makefile*"`;do
		sed -e "s:\(^CFLAGS =.*\):\1 ${CFLAGS}:" \
			-e "s:\(^CPPFLAGS =.*\):\1 ${CPPFLAGS}:" \
			${FILE} > ${FILE}.hacked || die "Hack failed"
		mv ${FILE}.hacked ${FILE}
	done
}	

src_compile() {

	CFLAGS="${CPPFLAGS} -Wno-error"
	CPPFLAGS="${CPPFLAGS} -Wno-deprecated"
	cp /usr/share/libtool/ltmain.sh .
	econf || die "Configure failed"
	emake || die "Make failed"
}

src_install() {

	make install prefix=${D}/usr || die "Install failed"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
	docinto Documentation
	dodoc Documentation/* 
}
