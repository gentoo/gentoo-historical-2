# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gnomeicu/gnomeicu-0.98.111.ebuild,v 1.3 2003/02/13 14:08:44 vapier Exp $

IUSE="nls esd gnome"

S=${WORKDIR}/${P}
DESCRIPTION="Gnome ICQ Client"
SRC_URI="mirror://sourceforge/gnomeicu/${P}.tar.bz2"
HOMEPAGE="http://gnomeicu.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86" 

DEPEND=">=x11-libs/gtk+-2.0.5
	>=dev-libs/libxml2-2.4.23
	>=gnome-base/libgnome-2.0.0
	>=gnome-base/libgnomeui-2.0.0
	>=sys-libs/gdbm-1.8.0
	>=gnome-base/libglade-2.0.0	
	>=net-libs/gnet-1.1.3
	gnome? ( >=gnome-base/gnome-panel-2.0.0 )
	esd? ( >=media-sound/esound-0.2.28 )"

	# socks5? ( something to support socks5 in portage is needed )

RDEPEND="nls? ( sys-devel/gettext )"


src_compile() {                           
	local myconf

	myconf="--prefix=/usr"

	use esd || myconf="${myconf} --disable-esd-test"
	
	# Disabling socks5 support. if socks5 is present
	# in USE, gnomeicu buid will fail. Check ChangeLog
	# for more info about this issue. stroke@gentoo.org 
	# use socks5 && myconf="${myconf} --enable-socks5"
	
	use nls || ( \
		myconf="${myconf} --disable-nls"
		mkdir ./intl
		touch ./intl/libgettext.h
	)

	# remove the panel applet if you dont use gnome,
	# nice hack for gnome2 compability

	use gnome || myconf="${myconf} --disable-applet" 	

	econf \
		${myconf} || die

	emake || die
}

src_install() {
	make DESTDIR=${D} \
	     sysconfdir=${D}/etc \
	     localstatedir=${D}/var/log	\
	     install || die

	dodoc AUTHORS COPYING CREDITS ChangeLog NEWS README TODO ABOUT-NLS
}
