# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-he/myspell-he-20060316.ebuild,v 1.16 2010/05/13 19:31:54 josejx Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"he,IL,he_IL,Hebrew (Israel),he_IL.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
)

MYSPELL_THESAURUS_DICTIONARIES=(
)

inherit myspell

DESCRIPTION="Hebrew dictionaries for myspell/hunspell"
LICENSE="GPL-2"
HOMEPAGE="http://lingucomponent.openoffice.org/ http://ivrix.org.il/projects/spell-checker/"
IUSE=""

KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd"
