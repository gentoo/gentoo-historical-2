# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Tools Team <tools@gentoo.org>
# Author: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/gtkskan/gtkskan-0.2.ebuild,v 1.1 2002/02/10 21:03:50 karltk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GTK+-based ESSID scanner"
SRC_URI="http://prdownloads.sourceforge.net/wavelan-tools/${P}.tgz"
HOMEPAGE="http://wavelan-tools.sf.net"

DEPEND="virtual/glibc
	=sys-libs/db-1.85*
	>=x11-libs/gtk+-1.2.10
	gnome? ( >=gnome-libs-1.4 gnome-core-1.4 )"
#RDEPEND=""

src_compile() {
	local myconf
	use gnome && myconf="--with-gnome" || myconf="--without-gnome"

	CFLAGS="${CFLAGS} -I." ./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		$myconf || die "./configure failed"
	ln -s /usr/include/db1/db.h src/db_185.h
	emake || die
}

src_install () {
	dodir /usr/bin
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	dodoc CREDITS LICENSE README
}
