# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/stardict-quick-eng-jpn/stardict-quick-eng-jpn-2.4.2.ebuild,v 1.2 2004/05/31 18:24:58 vapier Exp $

FROM_LANG="English"
TO_LANG="Japanese Romaji"
DICT_PREFIX="quick_"

inherit stardict

HOMEPAGE="http://stardict.sourceforge.net/Dictionaries_Quick.php"

KEYWORDS="~x86 ~ppc"

RDEPEND=">=app-dicts/stardict-2.4.2"
