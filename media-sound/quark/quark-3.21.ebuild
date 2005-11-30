# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/quark/quark-3.21.ebuild,v 1.1 2003/10/10 02:31:09 tseng Exp $

inherit gnome2

DESCRIPTION="Quark is the Anti-GUI Music Player with a cool Docklet!"
SRC_URI="http://quark.nerdnest.org/${P}.tar.gz"
HOMEPAGE="http://quark.nerdnest.org/"
SLOT="0"
IUSE=""

KEYWORDS="~x86 ~ppc ~alpha ~sparc"

LICENSE="GPL-2"

DEPEND=">=xine-lib-1_beta10
		>=gtk+-2.2.1
		>=gconf-2.2.0
		>=gnome-vfs-2.0.4-r2"

pkg_postinst () {
	einfo Quark is an anti-gui music player.
	einfo
	einfo Running the binary strange-quark will launch it in a
	einfo freedesktop.org dock ie: Gnome Notification Area
	einfo
}
