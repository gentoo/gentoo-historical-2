# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/nt/nt-1.30.ebuild,v 1.1 2002/01/05 00:03:46 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GTK based download manager for X."
SRC_URI="http://www.krasu.ru/soft/chuchelo/files/${P}.tar.gz"
HOMEPAGE="http://www.krasu.ru/soft/chuchelo/"

DEPEND="virtual/glibc
	virtual/x11
	>=x11-libs/gtk+-1.2.10-r4"

RDEPEND="virtual/glibc
	virtual/x11
	>=x11-libs/gtk+-1.2.10-r4"


src_compile() {

# This upstream developer does things a little strangely
	cd ${S}/main	
	emake DEST=/usr D4X_SHARE=/usr/share/nt || die
}

src_install () {

# Note to self and other developers: create directories in install targets of Makefiles....
	dodir /usr/bin
	dodir /usr/share/nt
	
	cd ${S}/main
	make DEST=${D}/usr D4X_SHARE=${D}/usr/share/nt install || die
   
	cd ${S}
	dodoc main/Changelog LICENSE THANKS FAQ* INSTALL* NAMES PLANS README* TODO TROUBLES
	
	doman nt.1
	
	insinto /usr/share/pixmaps
	doins *.png *.xpm

	if [ "use gnome" ] ; then
		insinto /usr/share/gnome/apps/Internet
		doins nt.desktop
	fi
}

