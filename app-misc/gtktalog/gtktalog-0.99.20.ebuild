# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gtktalog/gtktalog-0.99.20.ebuild,v 1.7 2002/10/05 05:39:09 drobbins Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="The GTK disk catalog."
SRC_URI="http://freesoftware.fsf.org/download/gtktalog/gtktalog/sources/${P}.tar.bz2"
HOMEPAGE="http://www.freesoftware.fsf.org/gtktalog"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="=x11-libs/gtk+-1.2*
	>=gnome-base/gnome-libs-1.4.1.2-r1
	>=sys-libs/zlib-1.1.4"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use nls || myconf="--disable-nls"
    
	econf \
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

	einstall || die

	dodoc AUTHORS BUGS COPYING ChangeLog NEWS README TODO
}
