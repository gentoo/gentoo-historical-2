# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkglext/gtkglext-0.3.1.ebuild,v 1.6 2002/12/09 04:41:47 manson Exp $

IUSE="doc"

DESCRIPTION="GL extentions for Gtk+ 2.0"
HOMEPAGE="http://http://gtkglext.sourceforge.net/"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86 sparc "

RDEPEND=">=x11-libs/gtk+-2.0.5
	virtual/glu
	virtual/opengl"

DEPEND="${DEPEND} 
	 doc? ( >=dev-util/gtk-doc-0.9 )"
SRC_URI="http://unc.dl.sourceforge.net/sourceforge/gtkglext/${P}.tar.bz2"
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
