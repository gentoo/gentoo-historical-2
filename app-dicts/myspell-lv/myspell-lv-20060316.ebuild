# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-lv/myspell-lv-20060316.ebuild,v 1.12 2008/01/06 15:29:43 ranger Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"lv,LV,lv_LV,Latvian (Latvia),lv_LV.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Latvian dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
