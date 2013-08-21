# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/plasma-mediacenter/plasma-mediacenter-1.1.0.ebuild,v 1.1 2013/08/21 07:41:53 kensington Exp $

EAPI=5

DECLARATIVE_REQUIRED="always"
OPENGL_REQUIRED="always"
KDE_LINGUAS="ca cs da de es fi fr gl hu lv nl pt pt_BR sk sl sv uk zh_TW"
inherit kde4-base

DESCRIPTION="Unified media experience for any device capable of running KDE"
HOMEPAGE="http://www.kde.org/ http://community.kde.org/Plasma/Plasma_Media_Center"

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}a.tar.bz2"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep nepomuk-core)
	dev-qt/qt-mobility[multimedia,qml]
	media-libs/taglib
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}
