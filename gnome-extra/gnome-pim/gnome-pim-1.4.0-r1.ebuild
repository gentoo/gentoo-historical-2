# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-pim/gnome-pim-1.4.0-r1.ebuild,v 1.1 2001/10/06 20:15:36 hallski Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="gnome-pim"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/gnome-pim/"${A}
HOMEPGAE="http://www.gnome.org/gnome-office/gnome-pim.shtml"

RDEPEND=">=gnome-base/gnome-libs-1.2.13"

DEPEND="${RDEPEND}
	>=gnome-base/gnome-core-1.4.0
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi

	./configure --host=${CHOST}					\
		    --prefix=/usr					\
		    --sysconfdir=/etc $myconf || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING* ChangeLog NEWS README*
}
