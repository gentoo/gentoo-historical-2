# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libexif-gtk/libexif-gtk-0.3.3.ebuild,v 1.3 2003/02/28 16:54:59 liquidx Exp $

inherit flag-o-matic

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="GTK frontend to the libexif library (parsing, editing, and saving EXIF data)"
SRC_URI="mirror://sourceforge/libexif/${P}.tar.gz"
HOMEPAGE="http://libexif.sf.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND="dev-util/pkgconfig
		>=x11-libs/gtk+-2.0
		>=media-libs/libexif-0.5.9"

src_compile() {
	local myconf
	use nls || myconf="${myconf} --disable-nls"
	econf ${myconf}
	emake || die
}

src_install() {
	dodir /usr/lib
	dodir /usr/include/libexif-gtk
	dodir /usr/share/locale
	dodir /usr/lib/pkgconfig
	einstall || die
}
