# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/stardict-xdict-en-zh-big5/stardict-xdict-en-zh-big5-2.4.2.ebuild,v 1.6 2005/08/02 20:29:27 gustavoz Exp $

FROM_LANG="English"
TO_LANG="Traditional Chinese (BIG5)"
DICT_PREFIX="xdict-ec-"
DICT_SUFFIX="big5"

inherit stardict

HOMEPAGE="http://stardict.sourceforge.net/Dictionaries_zh_TW.php"

KEYWORDS="~x86 ~ppc ~sparc"
IUSE=""

RDEPEND=">=app-dicts/stardict-2.4.2"
