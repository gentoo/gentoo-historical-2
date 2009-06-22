# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-gl/myspell-gl-20060316.ebuild,v 1.14 2009/06/22 13:35:10 jer Exp $

# Note; since the Galician dictionary uses the Spanish
# hypenation file, it causes collision problems with
# app-dicts/myspell-es.  So the Galician dictionary
# is actually installed by the app-dicts/myspell-es
# package instead.

#MYSPELL_SPELLING_DICTIONARIES=(
#"gl,ES,gl_ES,Galician (Spain),gl_ES.zip"
#)

#MYSPELL_HYPHENATION_DICTIONARIES=(
#"gl,ES,hyph_es_ES,Galician (Spain),hyph_es_ES.zip"
#)

#MYSPELL_THESAURUS_DICTIONARIES=(
#)

#inherit myspell

DESCRIPTION="Galician dictionaries for myspell/hunspell"
LICENSE="GPL-2 LGPL-2.1"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ~ppc64 ~sh sparc x86 ~x86-fbsd"

IUSE=""

SLOT="0"

RDEPEND="app-dicts/myspell-es"
