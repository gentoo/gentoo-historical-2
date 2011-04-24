# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/cantarell/cantarell-0.0.6.ebuild,v 1.1 2011/04/24 15:39:25 nirbheek Exp $

EAPI="3"
GNOME_ORG_MODULE="${PN}-fonts"

inherit font gnome.org

DESCRIPTION="Cantarell fonts, default fontset for GNOME Shell"
HOMEPAGE="http://live.gnome.org/CantarellFonts"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/fontconfig"
DEPEND=">=dev-util/pkgconfig-0.19"

DOCS="NEWS README"

# Font eclass settings
FONT_CONF=("${S}/fontconfig/31-cantarell.conf")
FONT_S="${S}/otf"
FONT_SUFFIX="otf"
