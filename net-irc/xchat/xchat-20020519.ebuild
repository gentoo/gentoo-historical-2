# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat/xchat-20020519.ebuild,v 1.1 2002/05/27 15:18:02 spider Exp $

# Python is DISABLED 

S=${WORKDIR}/${P}
DESCRIPTION="X-Chat is a graphical IRC client for UNIX operating systems."
SRC_URI="http://www.xchat.org/files/source/1.9/${P}.tar.bz2"
HOMEPAGE="http://www.xchat.org/"
LICENSE="GPL-2"
SLOT=0

RDEPEND=">=dev-libs/glib-2.0.1
	>=x11-libs/gtk+-2.0.1
	perl?   ( >=sys-devel/perl-5.6.1 )
	gnome? ( >=x11-libs/libzvt-1.115.2
			>=gnome-base/libgnome-1.117.1
			>=gnome-base/gnome-applets-1.103.0
			>=gnome-base/gnome-panel-1.5.22 )" 
               

DEPEND="${RDEPEND}
	nls? ( >=sys-devel/gettext-0.10.38 )"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {

	local myopts myflags

	use gnome \
		&& myopts="${myopts} --enable-gnome --enable-panel" \
		|| myopts="${myopts} --enable-gtkfe --disable-gnome --disable-zvt --disable-gdk-pixbuf"
	
	use gnome \
		&& CFLAGS="${CFLAGS} -I/usr/include/orbit-2.0" \
		|| myopts="${myopts} --disable-gnome"

	use gtk \
		|| myopts="${myopts} --disable-gtkfe"
	
	use ssl \
		&& myopts="${myopts} --enable-openssl"

	use perl \
		|| myopts="${myopts} --disable-perl"

	use nls \
		&& myopts="${myopts} --enable-hebrew --enable-japanese-conv" \
		|| myopts="${myopts} --disable-nls"

	use mmx	\
		&& myopts="${myopts} --enable-mmx"	\
		|| myopts="${myopts} --disable-mmx"
	
	use ipv6 \
		&& myopts="${myopts} --enable-ipv6"
	
	
	./configure \
		--prefix=/usr \
		--host=${CHOST} \
		${myopts} || die
	
	emake || die
}

src_install() {

	make prefix=${D}/usr utildir=${D}${KDEDIR}/share/applnk/Internet install || die

	use gnome && 
	(	insinto /usr/share/gnome/apps/Internet
		doins xchat.desktop  )

	dodoc AUTHORS COPYING ChangeLog README
}
