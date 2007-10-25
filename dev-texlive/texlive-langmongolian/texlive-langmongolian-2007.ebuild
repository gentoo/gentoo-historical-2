# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langmongolian/texlive-langmongolian-2007.ebuild,v 1.4 2007/10/25 14:34:13 armin76 Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="hyphen-mongolian montex soyombo collection-langmongolian
"
inherit texlive-module
DESCRIPTION="TeXLive Mongolian"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha ~ia64 ~sparc ~x86"
