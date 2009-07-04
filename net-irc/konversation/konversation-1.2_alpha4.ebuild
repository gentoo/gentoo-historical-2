# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/konversation/konversation-1.2_alpha4.ebuild,v 1.1 2009/07/04 09:22:03 scarabeus Exp $

EAPI="2"

KDE_LINGUAS="ar bg ca da de el en_GB es et fr gl he it ja ko nds nl pt pt_BR ru sv
tr uk zh_CN zh_TW"
inherit kde4-base versionator

MY_P="${PN}"-$(replace_version_separator 2 '-')

DESCRIPTION="A user friendly IRC Client for KDE4"
HOMEPAGE="http://konversation.kde.org"
SRC_URI="mirror://berlios/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="+crypt debug"

DEPEND="
	>=kde-base/kdepimlibs-${KDE_MINIMAL}
	crypt? ( app-crypt/qca:2 )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	mycmakeargs="$(cmake-utils_use_with crypt QCA2)"
	kde4-base_src_configure
}
