# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/users-guide/users-guide-1.2-r1.ebuild,v 1.9 2003/02/13 12:24:12 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="gnome-users-guide"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
KEYWORDS="x86 ppc sparc "
LICENSE="GPL-2"

DEPEND="gnome-base/gnome-core"

src_compile() {
	sed 's%\help/users-guide%help/gnome-users-guide%' Makefile.am > tmp~
	mv tmp~ Makefile.am
	sed 's%\help/users-guide%help/gnome-users-guide%' Makefile.in > tmp~
	mv tmp~ Makefile.in

	./configure --host=${CHOST}					\
		    --prefix=/usr
	assert

	emake || die
}

src_install() {
	make prefix=${D}/usr install || die

	dodoc AUTHORS COPYING* ChangeLog NEWS README* TODO
}
