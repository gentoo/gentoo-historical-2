# Copyright 2006-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-el/myspell-el-20060316.ebuild,v 1.10 2007/12/25 20:44:21 jer Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"el,GR,el_GR,Greek (Greece),el_GR.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"el,GR,hyph_el_GR,Greek (Greece),hyph_el_GR.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Greek dictionaries for myspell/hunspell"
LICENSE="GPL-2 LGPL-2.1"
HOMEPAGE="http://lingucomponent.openoffice.org/ http://ispell.source.gr http://interzone.gr"

KEYWORDS="amd64 ~hppa ppc sparc x86 ~x86-fbsd"
