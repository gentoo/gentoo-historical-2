# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/nautilus/nautilus-2.2.4-r5.ebuild,v 1.8 2003/09/12 20:04:27 liquidx Exp $

inherit gnome2 eutils

DESCRIPTION="A filemanager for the Gnome2 desktop"
HOMEPAGE="http://www.gnome.org/projects/nautilus/"
SLOT="0"
LICENSE="GPL-2 LGPL-2 FDL-1.1"
KEYWORDS="~x86 ~ppc ~alpha ~sparc ~hppa ~amd64"
IUSE="oggvorbis cups"

RDEPEND="app-admin/fam-oss
	>=dev-libs/glib-2
	>=x11-libs/pango-1.1.2
	>=x11-libs/gtk+-2.1.1
	>=dev-libs/libxml2-2.4.7
	>=gnome-base/gnome-vfs-2.1.5
	>=media-sound/esound-0.2.27
	>=gnome-base/eel-${PV}
	>=gnome-base/gconf-1.2.1
	>=gnome-base/libgnome-2.1.1
	>=gnome-base/libgnomeui-2.1.1
	>=gnome-base/gnome-desktop-2.1
	>=media-libs/libart_lgpl-2.3.10
	>=gnome-base/libbonobo-2.1
	>=gnome-base/libbonoboui-2.2
	>=gnome-base/librsvg-2.0.1
	>=gnome-base/ORBit2-2.4
	sys-apps/eject
	x11-themes/gnome-icon-theme
	x11-themes/gnome-themes
	oggvorbis? ( media-sound/vorbis-tools )
	cups? ( net-print/libgnomecups
		net-print/gnome-cups-manager )"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/pkgconfig-0.12.0"

G2CONF="${G2CONF} --enable-gdialog=yes"

DOCS="AUTHORS COPYIN* ChangeLo* HACKING INSTALL MAINTAINERS NEWS README THANKS TODO"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-2-snap_to_grid-r1.patch
	if [ `use cups` ]; then
		epatch ${FILESDIR}/${PN}-2-x-printers.patch
		WANT_AUTOCONF_2_5=1 autoconf || die
		WANT_AUTOMAKE=1.4 automake || die
	fi
}

