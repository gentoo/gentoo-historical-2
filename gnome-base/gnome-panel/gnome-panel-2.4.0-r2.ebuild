# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-panel/gnome-panel-2.4.0-r2.ebuild,v 1.8 2003/12/13 00:33:10 gmsoft Exp $

inherit gnome2 eutils

SLOT="0"

DESCRIPTION="The Panel for Gnome2"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
KEYWORDS="x86 ~ppc alpha sparc hppa ~amd64 ia64"

# IUSE="doc menu"
IUSE="doc"
MAKEOPTS="${MAKEOPTS} -j1"

RDEPEND=">=x11-libs/gtk+-2.1
	>=x11-libs/libwnck-2.3
	>=gnome-base/ORBit2-2.4
	>=gnome-base/gnome-vfs-2.3
	>=gnome-base/gnome-desktop-2.3
	>=gnome-base/libbonoboui-2.1.1
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2.1.1
	>=gnome-base/libgnomeui-2.1
	>=gnome-base/gconf-2.3.1
	!gnome-extra/system-tray-applet"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.21
	doc? ( >=dev-util/gtk-doc-0.9 )"

DOCS="AUTHORS COPYING* ChangeLog HACKING INSTALL NEWS README"

src_unpack() {

	unpack ${A}

	cd ${S}
	# use menu && epatch ${FILESDIR}/menu-${PV}.patch
	# fix initial menu size
	epatch ${FILESDIR}/${PN}-2.4-panel_size.patch

	# Fix for drawers problems. (Bug #30809)
	epatch ${FILESDIR}/${PN}-${PV}-drawers_fix.patch

	# Fixes for more drawers problem. (Bug #31309)
	epatch ${FILESDIR}/${PN}-${PV}-autohide_fix.patch
	epatch ${FILESDIR}/${PN}-${PV}-drawers_expanding_fix.patch


	sed -i 's:--load:-v:' gnome-panel/Makefile.am

	WANT_AUTOMAKE=1.4 automake || die

	# FIXME : uh yeah, this is nice
	touch gnome-panel/blah
	chmod +x gnome-panel/blah
}

pkg_postinst() {

	gnome2_pkg_postinst

	einfo "setting panel gconf defaults..."
	GCONF_CONFIG_SOURCE=`${ROOT}/usr/bin/gconftool-2 --get-default-source`
	${ROOT}/usr/bin/gconftool-2 --direct --config-source ${GCONF_CONFIG_SOURCE} --load=/etc/gconf/schemas/panel-default-setup.entries

}
