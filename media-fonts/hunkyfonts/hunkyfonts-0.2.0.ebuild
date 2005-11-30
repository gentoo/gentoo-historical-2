# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/hunkyfonts/hunkyfonts-0.2.0.ebuild,v 1.1.1.1 2005/11/30 10:01:26 chriswhite Exp $

inherit font

IUSE=""

DESCRIPTION="Hunky Fonts are free TrueType fonts based on Bitstream's Vera fonts with additional letters."
HOMEPAGE="http://www.yoper.com/ariszlo/hunky.html"
SRC_URI="http://www.yoper.com/ariszlo/packages/SOURCES/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

FONT_S="${WORKDIR}/${P}/TTF"
FONT_SUFFIX="ttf"

DOCS="ChangeLog README"
