# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2 
# $Header: /var/cvsroot/gentoo-x86/net-im/gnomeicu/gnomeicu-0.98.ebuild,v 1.3 2002/07/11 06:30:46 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Gnome ICQ Client"
SRC_URI="http://download.sourceforge.net/gnomeicu/${P}.tar.gz"
HOMEPAGE="http://gnomeicu.sourceforge.net/"
SLOT="0"
RDEPEND=">=gnome-base/gnome-libs-1.4.1.2-r2
	 >=sys-libs/gdbm-1.8.0
	 >=gnome-base/libglade-0.16
	 >=media-libs/gdk-pixbuf-0.9.0	
	 >=net-libs/gnet-1.1.0
	 esd? ( >=media-sound/esound-0.2.23 )"

DEPEND="${RDEPEND}
	sys-devel/gettext"

src_compile() {                           
	local myconf

	if [ -z "`use esd`" ]
	then
		myconf="--disable-esd-test"
	fi
	if [ "`use socks5`" ];
	then
		myconf="${myconf} --enable-socks5"
	fi
	
	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --sysconfdir=/etc \
		    --localstatedir=/var/lib \
		    ${myconf} || die

	emake || die
}

src_install() {
	make prefix=${D}/usr \
	     sysconfdir=${D}/etc \
	     localstatedir=${D}/var/log	\
	     install || die

	dodoc AUTHORS COPYING CREDITS ChangeLog NEWS README TODO ABOUT-NLS
}
