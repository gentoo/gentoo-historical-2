# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-wallpapers/kdeartwork-wallpapers-4.11.5.ebuild,v 1.4 2014/02/16 07:18:58 ago Exp $

EAPI=5

RESTRICT="binchecks strip"

KMMODULE="wallpapers"
KMNAME="kdeartwork"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="Wallpapers from kde"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

KMEXTRA="
	HighResolutionWallpapers/
"

RDEPEND="!<kde-base/kde-wallpapers-4.9.50:4"
