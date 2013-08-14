# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/poxml/poxml-4.11.0.ebuild,v 1.1 2013/08/14 20:24:05 dilfridge Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="KDE utility to translate DocBook XML files using gettext po files"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug extras"

DEPEND="
	extras? ( >=dev-java/antlr-2.7.7:0[cxx,java,script] )
"
RDEPEND="${DEPEND}
	!<=kde-base/kdesdk-misc-4.10.50:4
"

# java deps on anltr cant be properly explained to cmake deps
# needs to be run in one thread
MAKEOPTS+=" -j1"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with extras Antlr2)
	)

	kde4-base_src_configure
}
