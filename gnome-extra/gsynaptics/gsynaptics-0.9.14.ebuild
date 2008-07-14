# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gsynaptics/gsynaptics-0.9.14.ebuild,v 1.1 2008/07/14 13:14:18 eva Exp $

inherit eutils gnome2

DESCRIPTION="A GTK+ based configuration utility for the synaptics driver"
HOMEPAGE="http://gsynaptics.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/29684/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.10
		 >=x11-libs/gtk+-2.6.0
		 >=gnome-base/gconf-2.0
		 >=gnome-base/libglade-2"
DEPEND="${DEPEND}
		 >=dev-util/pkgconfig-0.19
		 app-text/gnome-doc-utils
		 sys-devel/gettext"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_unpack() {
	gnome2_src_unpack

	# Fix ?
	epatch "${FILESDIR}/${PN}-0.9.13-CoastingSpeedThreshold.patch"

	# Fix crash on startup, thanks to debian folks, bug #210958
	epatch "${FILESDIR}/${P}-build-filename.patch"
}

pkg_postinst() {
	gnome2_pkg_postinst

	echo
	elog "Ensure that the following line is in the InputDevice section in"
	elog "your X config file (/etc/X11/xorg.conf):"
	elog
	elog "Option \"SHMConfig\" \"on\""
	elog
	echo
	elog "You need to add gsynaptics-init to your session to restore your"
	elog "settings the next time you log into GNOME:"
	elog "Desktop -> Preferences -> Sessions -> Start Programs -> Add"
	echo
}
