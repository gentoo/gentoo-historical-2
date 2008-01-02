# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-sv/myspell-sv-20060316.ebuild,v 1.11 2008/01/02 12:21:39 armin76 Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"sv,SE,sv_SE,Swedish (Sweden),sv_SE.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"sv,SE,hyph_sv_SE,Swedish(Sweden),hyph_sv_SE.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Swedish dictionaries for myspell/hunspell"
LICENSE="LGPL-2.1"
HOMEPAGE="http://lingucomponent.openoffice.org/ http://sv.speling.org/"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc sparc x86 ~x86-fbsd"
