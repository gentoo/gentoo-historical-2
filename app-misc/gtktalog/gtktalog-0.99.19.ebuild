# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Mikael Hallendal <hallski@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-misc/gtktalog/gtktalog-0.99.19.ebuild,v 1.2 2002/04/28 02:37:31 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The GTK disk catalog."
SRC_URI="http://freesoftware.fsf.org/download/gtktalog/gtktalog/sources/${P}.tar.bz2"
HOMEPAGE="http://www.freesoftware.fsf.org/gtktalog"

DEPEND=">=x11-libs/gtk+-1.2.10-r4
	>=gnome-base/gnome-libs-1.4.1.2-r1
	>=sys-libs/zlib-1.1.4
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use nls || myconf="--disable-nls"
    
	./configure --host=${CHOST}	\
		--prefix=/usr \
		--mandir=/usr/share/man \
		--sysconfdir=/etc \
		--enable-htmltitle \
		--enable-mp3info \
		--enable-aviinfo \
		--enable-mpeginfo \
		--enable-modinfo \
		--enable-ogginfo \
		--enable-catalog2 \
		--enable-catalog3 \
		${myconf} || die
	emake || die
}

src_install () {
 	# DESTDIR does not work for mo-files

	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		sysconfdir=${D}/etc \
		install || die

	dodoc AUTHORS BUGS COPYING ChangeLog NEWS README TODO
}
