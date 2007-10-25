# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langnorwegian/texlive-langnorwegian-2007.ebuild,v 1.4 2007/10/25 14:34:29 armin76 Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="hyphen-norwegian collection-langnorwegian
"
inherit texlive-module
DESCRIPTION="TeXLive Norwegian"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha ~ia64 ~sparc ~x86"
