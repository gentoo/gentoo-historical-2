# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2 
# $Header: /var/cvsroot/gentoo-x86/net-im/everybuddy/everybuddy-0.4.3.ebuild,v 1.4 2003/01/06 05:37:23 seemant Exp $

IUSE="arts esd gnome nls"

S=${WORKDIR}/${P}
DESCRIPTION="Universal Instant Messaging Client"
SRC_URI="http://www.everybuddy.com/files/${P}.tar.gz"
HOMEPAGE="http://www.everybuddy.com/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="=x11-libs/gtk+-1.2*
	arts? ( >=kde-base/arts-1.0.0 )
	gnome? ( >=gnome-base/gnome-libs-1.4.1.7 )
	esd? ( >=media-sound/esound-0.2.28 )"

src_compile() {
	local myconf
	use arts \
		&& myconf="--enable-arts" \
		|| myconf="--disable-arts"

	use esd \
		&& myconf="${myconf} --enable-esd" \
		|| myconf="${myconf} --disable-esd"

	use gnome \
		&& myconf="${myconf} --with-gnome" \
		|| myconf="${myconf} --without-gnome"

	
	use nls \
		&& myconf="${myconf} --enable-nls" \
		|| myconf="${myconf} --disable-nls"

	econf ${myconf} || die
	cp src/Makefile src/Makefile.old
	sed -e 's:EB_LIBS =  :EB_LIBS =  -laudiofile :' \
		src/Makefile.old > src/Makefile
	make || die

}

src_install () {

#	make \
#		DESTDIR=${D} \
#		install || die

	einstall || die
	dodoc AUTHORS NEWS README TODO COPYING ChangeLog

}
