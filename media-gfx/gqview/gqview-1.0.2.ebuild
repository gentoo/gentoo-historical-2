# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Santa Clause <sc@arctic.np>
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gqview/gqview-1.0.2.ebuild,v 1.2 2002/03/08 05:29:51 agenkin Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A GNOME image browser"
SRC_URI="http://prdownloads.sourceforge.net/gqview/${P}.tar.gz"
HOMEPAGE="http://gqview.sourceforge.net/"

DEPEND="virtual/glibc
	media-libs/libpng
	>=media-libs/gdk-pixbuf-0.16.0-r4
	>=x11-libs/gtk+-1.2.10-r4
	nls? ( sys-devel/gettext )"


src_compile() {

	local myconf
	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi

	./configure --prefix=/usr				\
		--mandir=/usr/share/man				\
		--infodir=/usr/share/info			\
		--sysconfdir=/etc				\
		--host=${CHOST}					\
		${myconf} || die

	emake || die
}

src_install() {

	make prefix=${D}/usr					\
		mandir=${D}/usr/share/man			\
		infodir=${D}/usr/share/info			\
		sysconfdir=${D}/etc				\
		GNOME_DATADIR=${D}/usr/share			\
		install || die
	
	dodoc AUTHORS COPYING ChangeLog README NEWS TODO
}

