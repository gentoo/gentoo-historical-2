# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Mikael Hallendal <hallski@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-admin/procman/procman-1.0.ebuild,v 1.1 2002/02/17 01:41:28 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Process viewer for GNOME"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/procman/${P}.tar.gz"
HOMEPAGE="http://www.personal.psu.edu/kfv101/procman"

DEPEND="nls? ( sys-devel/gettext )
        >=gnome-extra/gal-0.13-r1
	>=gnome-base/libgtop-1.0.12-r1"

src_compile() {
	local myconf

	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi

	CFLAGS="$CFLAGS `gdk-pixbuf-config --cflags`"

	./configure --host=${CHOST} 					\
		    --prefix=/usr					\
		    --sysconfdir=/etc					\
		    --localstatedir=/var/lib				\
		    --disable-more-warnings				\
		    $myconf || die

	emake || die
}

src_install () {
	make prefix=${D}/usr						\
	     sysconfdir=${D}/etc					\
	     localstatedir=${D}/var/lib					\
	     install || die

	dodoc AUTHORS COPYING ChangeLog README NEWS TODO
}
