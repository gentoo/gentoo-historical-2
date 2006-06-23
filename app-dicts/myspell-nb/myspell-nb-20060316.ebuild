# Copyright 2006-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-nb/myspell-nb-20060316.ebuild,v 1.5 2006/06/23 18:15:43 gustavoz Exp $

DESCRIPTION="Norwegian dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="http://lingucomponent.openoffice.org/ http://folk.uio.no/runekl/dictionary.html"

KEYWORDS="~amd64 ~ppc sparc ~x86 ~x86-fbsd"

MYSPELL_SPELLING_DICTIONARIES=(
"nb,NO,nb_NO,Norwegian Bokmaal (Norway),nb_NO.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell
