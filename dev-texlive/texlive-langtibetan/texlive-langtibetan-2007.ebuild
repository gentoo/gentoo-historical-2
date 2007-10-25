# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langtibetan/texlive-langtibetan-2007.ebuild,v 1.2 2007/10/25 12:45:40 fmccor Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="ctib otibet collection-langtibetan
"
inherit texlive-module
DESCRIPTION="TeXLive Tibetan"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~sparc"
