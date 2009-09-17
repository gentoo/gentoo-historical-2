# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/mplus-outline-fonts/mplus-outline-fonts-0_pre026.ebuild,v 1.1 2009/09/17 16:12:28 matsuu Exp $

inherit font

MY_P="mplus-${PV/0_pre/TESTFLIGHT-}"
DESCRIPTION="M+ Japanese outline fonts with IPA font"
HOMEPAGE="http://mplus-fonts.sourceforge.jp/ https://sourceforge.jp/projects/opfc/"
SRC_URI="mirror://sourceforge.jp/mplus-fonts/6650/${MY_P}.tar.gz"

LICENSE="mplus-fonts IPAfont"
SLOT="0"
#KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~x86"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="ipafont"

DEPEND="ipafont? (
		media-gfx/fontforge
		>=media-fonts/ja-ipafonts-003.01
	)"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

FONT_SUFFIX="ttf"
FONT_S="${S}"

DOCS="README_J README_J"

RESTRICT="strip binchecks"

IPAFONT_DIR="/usr/share/fonts/ja-ipafonts"
src_unpack() {
	unpack ${A}
	if use ipafont ; then
		cp -p "${IPAFONT_DIR}/ipag.otf" "${S}" || die
	fi
}

src_compile() {
	if use ipafont ; then
		fontforge -script m++ipa.pe || die
		rm -f ipag.otf || die
	fi
}
