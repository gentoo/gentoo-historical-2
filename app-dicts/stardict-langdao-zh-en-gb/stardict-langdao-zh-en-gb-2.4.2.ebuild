# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/stardict-langdao-zh-en-gb/stardict-langdao-zh-en-gb-2.4.2.ebuild,v 1.4 2005/01/04 15:19:08 citizen428 Exp $

FROM_LANG="English"
TO_LANG="Simplified Chinese (GB)"
DICT_PREFIX="langdao-ce-"
DICT_SUFFIX="gb"

inherit stardict

HOMEPAGE="http://stardict.sourceforge.net/Dictionaries_zh_CN.php"

KEYWORDS="x86 ~ppc"
IUSE=""

RDEPEND=">=app-dicts/stardict-2.4.2"
