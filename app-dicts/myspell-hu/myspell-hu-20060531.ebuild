# Copyright 2006-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-hu/myspell-hu-20060531.ebuild,v 1.3 2006/07/08 23:42:40 pylon Exp $

DESCRIPTION="Hungarian dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="http://magyarispell.sourceforge.net/
		http://www.tipogral.hu/index.rbx/site/projects/huhyphn
		http://lingucomponent.openoffice.org/"
SRC_URI="http://magyarispell.sourceforge.net/hu_HU-1.0.tar.gz
		http://www.tipogral.hu/download/huhyphn-20060531.tar.gz
		mirror://gentoo/myspell-thes_hu_HU-20060316.zip"

KEYWORDS="~amd64 ppc sparc ~x86 ~x86-fbsd"

MYSPELL_SPELLING_DICTIONARIES=(
"hu,HU,hu_HU_u8,Hungarian (Hungary),hu_HU-1.0.tar.gz"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"hu,HU,hyph_hu,Hungarian (Hungary),huhyphn-20050329.tar.gz"
)

MYSPELL_THESAURUS_DICTIONARIES=(
"hu,HU,th_hu_HU,Hungarian (Hungary),thes_hu_HU.zip"
)

inherit myspell

src_unpack() {
	unpack ${A}
	mv */* .
}
