# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-nl/myspell-nl-20090725.ebuild,v 1.5 2010/06/13 21:33:50 angelos Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"nl,NL,nl_NL,Dutch (Netherlands),nl_NL.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"nl,NL,hyph_nl_NL,Dutch (Netherlands), hyph_nl_NL.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Dutch dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="http://lingucomponent.openoffice.org/ http://wiki.services.openoffice.org/wiki/Dictionaries#Dutch_.28Netherlands.29"

KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 sh sparc ~x86 ~x86-fbsd"
