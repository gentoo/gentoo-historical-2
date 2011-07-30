# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-wallpapers/kde-wallpapers-4.7.0.ebuild,v 1.2 2011/07/30 12:53:36 dilfridge Exp $

EAPI=3

KMNAME="kde-wallpapers"
KDE_SCM="svn"
inherit kde4-base

DESCRIPTION="KDE wallpapers"
KEYWORDS="~amd64 ~x86"
IUSE=""

add_blocker kdebase-wallpapers

src_configure() {
	mycmakeargs=( -DWALLPAPER_INSTALL_DIR="${EPREFIX}/usr/share/wallpapers" )

	kde4-base_src_configure
}
