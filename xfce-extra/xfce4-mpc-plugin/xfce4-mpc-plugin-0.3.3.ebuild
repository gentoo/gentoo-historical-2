# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-mpc-plugin/xfce4-mpc-plugin-0.3.3.ebuild,v 1.1 2009/08/23 15:20:56 ssuominen Exp $

inherit xfconf

DESCRIPTION="Music Player Daemon (mpd) panel plugin"
HOMEPAGE="http://www.xfce.org/"
SRC_URI="mirror://xfce/src/panel-plugins/${PN}/0.3/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="debug libmpd"

RDEPEND=">=xfce-base/xfce4-panel-4.3.22
	libmpd? ( media-libs/libmpd )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	dev-perl/XML-Parser"

pkg_setup() {
	XFCONF="--disable-dependency-tracking
		$(use_enable debug)
		$(use_enable libmpd)"
	DOCS="AUTHORS ChangeLog README TODO"
}
