# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkglext/gtkglext-0.3.0-r1.ebuild,v 1.1 2002/06/27 04:40:45 spider Exp $

DESCRIPTION="GL extentions for Gtk+ 2.0"
HOMEPAGE="http://http://gtkglext.sourceforge.net/"
LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND=">=x11-libs/gtk+-2.0.5
	virtual/glu
	virtual/opengl"

DEPEND="${RDEPEND} 
	 doc? ( >=dev-util/gtk-doc-0.9 )"
SRC_URI="mirror://sourceforge/gtkglext/${P}.tar.bz2"
S=${WORKDIR}/${P}

src_compile() {
	local myconf
	use doc && myconf="${myconf} --enable-gtk-doc" || myconf="${myconf} --disable-gtk-doc"
	./configure \
		${myconf} \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING* ChangeLog* INSTALL NEWS* README* TODO
}
