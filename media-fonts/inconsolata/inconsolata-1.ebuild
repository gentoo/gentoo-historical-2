# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/inconsolata/inconsolata-1.ebuild,v 1.1 2008/07/23 01:33:45 yngwin Exp $

inherit font

DESCRIPTION="A beautiful sans-serif monotype font designed for code listings"
HOMEPAGE="http://www.levien.com/type/myfonts/inconsolata.html"
SRC_URI="http://www.levien.com/type/myfonts/Inconsolata.otf"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

FONT_SUFFIX="otf"
FONT_S="${WORKDIR}/${P}"

# Only installs fonts. File distributed without license.
RESTRICT="strip binchecks mirror"

src_unpack() {
	mkdir "${FONT_S}"
	cp "${DISTDIR}"/Inconsolata.otf "${FONT_S}"
}