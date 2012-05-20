# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnome-themes-standard/gnome-themes-standard-3.2.1.ebuild,v 1.10 2012/05/20 19:35:38 ssuominen Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Adwaita theme for GNOME Shell"
HOMEPAGE="http://www.gnome.org/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

COMMON_DEPEND="gnome-base/librsvg:2
	>=x11-libs/gtk+-3.1.18:3
	>=x11-themes/gtk-engines-2.15.3:2"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	sys-devel/gettext"
# gnome-themes{,-extras} are OBSOLETE for GNOME 3
# http://comments.gmane.org/gmane.comp.gnome.desktop/44130
RDEPEND="${COMMON_DEPEND}
	!<x11-themes/gnome-themes-2.32.1-r1"

# FIXME: --enable-placeholders fails
G2CONF="--disable-static --disable-placeholders"
DOCS="ChangeLog NEWS"

src_prepare() {
	gnome2_src_prepare
	# Install cursors in the right place
	sed -e 's:^\(cursordir.*\)icons\(.*\):\1cursors/xorg-x11\2:' \
		-i themes/Adwaita/cursors/Makefile.am \
		-i themes/Adwaita/cursors/Makefile.in || die
}

src_install() {
	gnome2_src_install

	# Make it the default cursor theme
	cd "${ED}/usr/share/cursors/xorg-x11" || die
	ln -sfn Adwaita default || die
}
