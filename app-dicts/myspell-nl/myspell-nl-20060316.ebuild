# Copyright 2006-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-nl/myspell-nl-20060316.ebuild,v 1.2 2006/05/19 21:17:49 flameeyes Exp $

DESCRIPTION="Dutch dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="http://lingucomponent.openoffice.org/ http://www.goddijn.com/words.htm"

KEYWORDS="~amd64 ~x86 ~x86-fbsd"

MYSPELL_SPELLING_DICTIONARIES=(
"nl,NL,nl_med,Dutch (medical),nl_med.zip"
"nl,NL,nl_NL,Dutch (Netherlands),nl_NL.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"nl,NL,hyph_nl_NL,Dutch (Netherlands), hyph_nl_NL.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell
