# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-panel/gnome-panel-2.4.2.ebuild,v 1.12 2004/06/24 21:57:57 agriffis Exp $

inherit gnome2 eutils

DESCRIPTION="The Panel for Gnome2"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2 FDL-1.1 LGPL-2"

# IUSE="doc menu"
IUSE="doc"
KEYWORDS="x86 ppc alpha sparc hppa amd64 ia64 mips"
SLOT="0"

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
	media-libs/libpng
	!gnome-extra/system-tray-applet"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.29
	doc? ( >=dev-util/gtk-doc-0.9 )"
# agh. ./configure check for XML::Parser.

DOCS="AUTHORS COPYING* ChangeLog HACKING INSTALL NEWS README"

src_unpack() {

	unpack ${A}
	cd ${S}
	# use menu && epatch ${FILESDIR}/menu-${PV}.patch

	# fix calendar day-of-week for l10n, see bug #38672
	# consider clean/removing for gtk+-2.4/gnome-2.6
	epatch ${FILESDIR}/${PN}-calendar-l10n.patch

	# fix initial menu size
	epatch ${FILESDIR}/${PN}-2.4-panel_size.patch

	sed -i 's:--load:-v:' gnome-panel/Makefile.am

	WANT_AUTOMAKE=1.4 automake || die

}

pkg_postinst() {

	gnome2_pkg_postinst

	einfo "setting panel gconf defaults..."
	GCONF_CONFIG_SOURCE=`${ROOT}/usr/bin/gconftool-2 --get-default-source`
	${ROOT}/usr/bin/gconftool-2 --direct --config-source ${GCONF_CONFIG_SOURCE} --load=/etc/gconf/schemas/panel-default-setup.entries

}
