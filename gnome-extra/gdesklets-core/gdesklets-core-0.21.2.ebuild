# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gdesklets-core/gdesklets-core-0.21.2.ebuild,v 1.1 2003/09/14 10:01:26 obz Exp $

inherit gnome2

MY_PN="gDesklets"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="GNOME Desktop Applets: core library for the desktop applets"
SRC_URI="http://www.pycage.de/download/gdesklets/${MY_P}.tar.bz2"
HOMEPAGE="http://www.pycage.de/software_gdesklets.html"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="~x86"

RDEPEND=">=dev-lang/python-2.2
	>=gnome-base/gconf-2
	>=dev-python/pygtk-1.99.14
	>=dev-python/gnome-python-1.99.14
	>=x11-libs/gtk+-2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool"

USE_DESTDIR="1"
DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"

src_unpack( ) {

	unpack ${A}
	cd ${S}
	# patch to prevent building the External and FontSelector
	# sensors included here, because we're using the ones
	# from x11-plugins/
	epatch ${FILESDIR}/gdesklets-core-0.21-Sensors.patch

}

src_install( ) {

	gnome2_src_install
	# there are two links that end up pointing inside the
	# image that we need to fix up here
	dosym /usr/share/gdesklets/gdesklets /usr/bin/gdesklets
	dosym /usr/share/pixmaps/gdesklets.png \
		  /usr/share/gdesklets/data/gdesklets.png

	# and install the display navigation desktop
	insinto /usr/share/applications
	doins ${FILESDIR}/gdesklets-displays.desktop

}

pkg_postinst( ) {

	echo ""
	einfo "gDesklets Displays are required before the library"
	einfo "will be usable for you. The displays are found in - "
	einfo "           x11-plugins/desklet-*"
	einfo "Please install at least one of these before using"
	einfo "gDesklets. Next, you'll need to run 'gdesklets' "
	einfo "and then add the Displays from - "
	einfo "         /usr/share/gdesklets/Displays"
	einfo "If you're using GNOME this can be done conveniently"
	einfo "through Applications->Accessories menu"
	echo ""
	ewarn "If you are updating from a previous version of gDesklets"
	ewarn "you may need to re-emerge Displays that complain on"
	ewarn "startup"
	echo ""

}

