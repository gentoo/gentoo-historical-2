# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-chewing/ibus-chewing-1.0.2.20090302.ebuild,v 1.1 2009/03/02 14:56:56 matsuu Exp $

EAPI="1"
inherit cmake-utils

MY_P="${P}-Source"
DESCRIPTION="The Chewing IMEngine for IBus Framework"
HOMEPAGE="http://code.google.com/p/ibus/"
SRC_URI="http://ibus.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=app-i18n/ibus-1
	>=dev-libs/libchewing-0.3.2
	x11-libs/gtk+:2
	gnome-base/gconf:2
	dev-util/gob:2"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

CMAKE_IN_SOURCE_BUILD=1

DOCS="AUTHORS ChangeLog NEWS README"
