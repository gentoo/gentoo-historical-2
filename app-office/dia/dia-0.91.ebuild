# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/dia/dia-0.91.ebuild,v 1.9 2003/09/21 16:49:34 foser Exp $

inherit gnome2

DESCRIPTION="Diagram Creation Program"
HOMEPAGE="http://www.gnome.org/gnome-office/dia.shtml"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc"
IUSE="gnome png python"

DEPEND=">=x11-libs/gtk+-2.0.0
	<=x11-libs/pango-1.2.3
	>=dev-libs/libxml2-2.3.9
	>=dev-libs/libxslt-1.0
	>=media-libs/freetype-2.0.9
	>=dev-util/intltool-0.21
	png? ( media-libs/libpng
		media-libs/libart_lgpl )
	gnome? ( >=gnome-base/libgnome-2.0
		>=gnome-base/libgnomeui-2.0 )
	python? ( >=dev-lang/python-2.0
		>=dev-python/pygtk-1.99 )"

G2CONF="${G2CONF} `use_enable gnome` `use_with python`"

src_unpack() {

	unpack ${A}

	# fix b0rked Makefile in Cisco directory
	einfo "Patching shapes/Cisco/Makefile.in"
	cd ${S}
	cp ${FILESDIR}/${P}-Cisco-Makefile.in ${S}/shapes/Cisco/Makefile.in || die

	epatch ${FILESDIR}/${P}-gcc33_fix.patch

}

src_install() {

	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog README NEWS TODO KNOWN_BUGS

	# fix .desktop link
	dodir /usr/share/applications
	mv ${D}/usr/share/gnome/apps/Applications/dia.desktop ${D}/usr/share/applications/dia.desktop
	rmdir ${D}/usr/share/gnome/apps/Applications
	rmdir ${D}/usr/share/gnome/apps
	echo "Categories=Application;GNOME;Office;" >> ${D}/usr/share/applications/dia.desktop

}
