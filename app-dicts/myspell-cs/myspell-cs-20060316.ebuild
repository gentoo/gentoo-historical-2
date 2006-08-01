# Copyright 2006-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-cs/myspell-cs-20060316.ebuild,v 1.9 2006/08/01 14:24:25 blubb Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"cs,CZ,cs_CZ,Czech (Czech Republic),cs_CZ.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"cs,CZ,hyph_cs_CZ,Czech (Czech Republic),hyph_cs_CZ.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
"cs,CZ,th_cs_CZ,Czech (Czech Republic),thes_cs_CZ.zip"
)

inherit myspell

DESCRIPTION="Czech dictionaries for myspell/hunspell"
LICENSE="GPL-2 myspell-th_cs_CZ-PavelRychlySmrz"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd"
