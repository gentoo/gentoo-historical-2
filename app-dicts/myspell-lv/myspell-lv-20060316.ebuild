# Copyright 2006-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-lv/myspell-lv-20060316.ebuild,v 1.2 2006/05/19 21:13:47 flameeyes Exp $

DESCRIPTION="Latvian dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="~amd64 ~x86 ~x86-fbsd"

MYSPELL_SPELLING_DICTIONARIES=(
"lv,LV,lv_LV,Latvian (Latvia),lv_LV.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell
