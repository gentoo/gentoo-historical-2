# Copyright 2006-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/myspell-sk/myspell-sk-20060316.ebuild,v 1.10 2007/12/25 20:58:17 jer Exp $

MYSPELL_SPELLING_DICTIONARIES=(
"sk,SK,sk_SK,Slovak (Slovakia),sk_SK.zip"
)

MYSPELL_HYPHENATION_DICTIONARIES=(
"sk,SK,hyph_sk_SK,Slovak (Slovakia),hyph_sk_SK.zip"
)

MYSPELL_THESAURUS_DICTIONARIES=(
"sk,SK,th_sk_SK,Slovak (Slovakia),thes_sk_SK.zip"
)

inherit myspell

DESCRIPTION="Slovak dictionaries for myspell/hunspell"
LICENSE="GPL-2 LGPL-2.1 MPL-1.1 myspell-hyph_sk_SK-TiborBako"
HOMEPAGE="http://lingucomponent.openoffice.org/"

KEYWORDS="amd64 ~hppa ppc sparc x86 ~x86-fbsd"
