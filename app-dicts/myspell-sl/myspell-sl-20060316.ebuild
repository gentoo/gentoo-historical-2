# Copyright 2006-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-sl/myspell-sl-20060316.ebuild,v 1.8 2006/07/16 08:09:06 tsunam Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"sl,SI,sl_SI,Slovenian (Slovenia),sl_SI.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"sl,SI,hyph_sl_SI,Slovenian (Slovenia),hyph_sl_SI.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Slovenian dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="~amd64 ppc sparc x86 ~x86-fbsd"
