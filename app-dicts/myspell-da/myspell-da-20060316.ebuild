# Copyright 2006-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-da/myspell-da-20060316.ebuild,v 1.2 2006/05/19 21:00:08 flameeyes Exp $

DESCRIPTION="Danish dictionaries for myspell/hunspell"
LICENSE="GPL-2 LGPL-2.1"
HOMEPAGE="http://lingucomponent.openoffice.org/ http://da.speling.org/"

KEYWORDS="~amd64 ~x86 ~x86-fbsd"

MYSPELL_SPELLING_DICTIONARIES=(
"da,DK,da_DK,Danish (Denmark),da_DK.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"da,DK,hyph_da_DK,Danish (Denmark),hyph_da_DK.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell
