# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/zapping/zapping-0.6.2-r1.ebuild,v 1.5 2002/10/04 05:57:52 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Zapping is a TV- and VBI- viewer for the Gnome environment."
SRC_URI="http://telia.dl.sourceforge.net/${PN}/${P}.tar.bz2"
HOMEPAGE="http://zapping.sourceforge.net"

DEPEND=">=gnome-base/gnome-libs-1.4.1.2-r1
	>=gnome-base/libglade-0.17-r1
	=x11-libs/gtk+-1.2*
	dev-libs/libunicode"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_compile() {
	
	local myconf

	use nls || myconf="${myconf} --disable-nls"
	use pam && myconf="${myconf} --enable-pam"
	use X \
		&& myconf="${myconf} --with-x" \
		|| myconf="${myconf} --without-x"

	econf ${myconf} || die

	mv src/Makefile src/Makefile.orig
	sed -e \
		"s:\(INCLUDES = \$(COMMON_INCLUDES)\):\1 -I/usr/include/libglade-1.0 -I/usr/include/gdk-pixbuf-1.0:" \
		src/Makefile.orig > src/Makefile
	
	make || die
}

src_install () {
	einstall \
		PACKAGE_LIB_DIR=${D}/usr/lib/zapping \
		PACKAGE_PIXMAPS_DIR=${D}/usr/share/pixmaps/zapping \
		PLUGIN_DEFAULT_DIR=${D}/usr/lib/zapping/plugins \
		|| die

	rm ${D}/usr/bin/zapzilla
	dosym /usr/bin/zapping /usr/bin/zapzilla
	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}
