# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeprint/libgnomeprint-1.114.0.ebuild,v 1.2 2002/07/11 06:30:26 drobbins Exp $

# Do _NOT_ strip symbols in the build! Need both lines for Portage 1.8.9+
DEBUG="yes"
RESTRICT="nostrip"
# force debug information
CFLAGS="${CFLAGS} -g"
CXXFLAGS="${CXXFLAGS} -g"


S=${WORKDIR}/${P}
DESCRIPTION="Printer handling for Gnome"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"


RDEPEND=">=gnome-base/libbonobo-1.117.0
	>=media-libs/libart_lgpl-2.3.8
	>=x11-libs/pango-1.0.0
	>=dev-libs/libxml2-2.4.22
	>=dev-libs/glib-2.0.0
	>=media-libs/freetype-2.0.9"
		
DEPEND="${RDEPEND} 
	>=dev-util/pkgconfig-0.12.0"
	
src_compile() {
	local myconf

	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--disable-font-install \
		--enable-platform-gnome-2 || die "configure failure"

	emake || die "compile failure"
}

src_install() {
	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		infodir=${D}/usr/share/info \
		mandir=${D}/usr/share/man \
		install || die
    
	dodoc AUTHORS COPYING*  ChangeLog* INSTALL NEWS README 
}

pkg_postinst() {
	echo ">>> Updating Fonts"
	libgnomeprint-2.0-font-install \
		--debug \
		--smart \
		--static \
		--aliases=/usr/share/gnome/libgnomeprint-2.0/fonts/adobe-urw.font \
		--target=/usr/share/gnome/libgnomeprint-2.0/fonts/gnome-print.fontmap
				
} 


