# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gsynaptics/gsynaptics-0.9.10.ebuild,v 1.5 2008/02/22 05:06:37 compnerd Exp $

inherit gnome2

DESCRIPTION="A GTK+ based configuration utility for the synaptics driver"
HOMEPAGE="http://gsynaptics.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/22897/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6.0
		 >=gnome-base/libglade-2
		 >=gnome-base/libgnomeui-2"
DEPEND="${DEPEND}
		 >=dev-util/pkgconfig-0.19
		 sys-devel/gettext"

DOCS="AUTHORS ChangeLog NEWS README TODO"

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
