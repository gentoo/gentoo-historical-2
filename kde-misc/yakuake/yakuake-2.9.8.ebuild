# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/yakuake/yakuake-2.9.8.ebuild,v 1.5 2011/06/01 19:51:19 ranger Exp $

EAPI=3

KDE_LINGUAS="ca cs da de el en_GB es et fr ga gl hr it ja ko nb nds nl nn pl pt
pt_BR ro ru sk sv th tr uk wa zh_CN"
inherit kde4-base

DESCRIPTION="A quake-style terminal emulator based on KDE konsole technology"
HOMEPAGE="http://yakuake.kde.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="amd64 ppc ~ppc64 x86"
SLOT="4"
IUSE=""

DEPEND="$(add_kdebase_dep konsole)
	sys-devel/gettext"
RDEPEND="${DEPEND}"
