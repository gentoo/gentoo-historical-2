# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/fox/fox-1.2.6-r1.ebuild,v 1.1 2004/08/23 18:54:22 s4t4n Exp $

IUSE="cups debug freetype opengl"
DESCRIPTION="C++ based Toolkit for developing Graphical User Interfaces easily and effectively"
SRC_URI="http://www.fox-toolkit.org/ftp/${P}.tar.gz"
HOMEPAGE="http://www.fox-toolkit.org"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
LICENSE="GPL-2"

DEPEND="virtual/libc
	virtual/x11
	freetype? ( >=media-libs/freetype-2.1.5-r1 )
	opengl? ( virtual/opengl )"


src_compile() {
	local myconf

	use opengl || myconf="$myconf --with-opengl=no" #default enabled
	myconf="$myconf `use_enable cups`"              #default disabled
	myconf="$myconf `use_enable debug`"             #default disabled
	use freetype && myconf="$myconf --with-xft"     #default disabled

	./configure \
		--prefix=/usr \
		--mandir='${prefix}'/share/man \
		--host=${CHOST} \
		${myconf} || die "Configuration Failed"

	emake || die "Parallel Make Failed"
}

src_install () {

	make prefix=${D}/usr/ \
		install || die "Installation Failed"

	dodoc README INSTALL LICENSE ADDITIONS AUTHORS TRACING

	dodir /usr/share/doc/${PF}/html
	mv ${D}/usr/fox/html/* ${D}/usr/share/doc/${PF}/html/
	rmdir ${D}/usr/fox/html
	rmdir ${D}/usr/fox
}
