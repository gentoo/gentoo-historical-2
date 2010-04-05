# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kaffeine/kaffeine-1.0_pre3.ebuild,v 1.3 2010/04/05 20:15:15 ssuominen Exp $

EAPI=2
KDE_LINGUAS="ast be ca ca@valencia cs da de el en_GB eo es et fi fr ga gl hr hu
it ja km ko ku lt mai nb nds nl nn pa pl pt pt_BR ro ru se sk sv th tr uk zh_CN
zh_TW"
inherit kde4-base

MY_P=${P/_/-}

DESCRIPTION="A media player for KDE with digital TV support"
HOMEPAGE="http://kaffeine.kde.org/"
SRC_URI="mirror://sourceforge/kaffeine/${MY_P}.tar.gz"

LICENSE="GPL-2 FDL-1.2"
SLOT="4"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="debug"

DEPEND="x11-libs/qt-sql:4[sqlite]
	>=media-libs/xine-lib-1.1.17
	>=kde-base/solid-${KDE_MINIMAL}"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS Changelog NOTES TODO"

src_configure() {
	mycmakeargs+=( $(cmake-utils_use_build debug DEBUG_MODULE) )
	kde4-base_src_configure
}
