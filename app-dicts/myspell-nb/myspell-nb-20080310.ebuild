# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-nb/myspell-nb-20080310.ebuild,v 1.4 2010/05/13 19:41:11 josejx Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"nb,NO,nb_NO,Norwegian bokmål (Norway),nb_NO.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"nb,NO,hyph_nb_NO,Norwegian bokmål (Norway),hyph_nb_NO.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
"nb,NO,th_nb_NO_v2,Norwegian bokmål (Norway),th_nb_NO_v2.zip"
)

inherit myspell

DESCRIPTION="Norwegian dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="http://spell-norwegian.alioth.debian.org/"

KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~ppc ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
