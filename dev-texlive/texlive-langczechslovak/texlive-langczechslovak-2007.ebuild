# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langczechslovak/texlive-langczechslovak-2007.ebuild,v 1.2 2007/10/25 07:18:27 opfer Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
dev-texlive/texlive-latex
"
TEXLIVE_MODULE_CONTENTS="bin-cslatex bin-csplain bin-vlna cs cslatex csplain hyphen-czechslovak collection-langczechslovak
"
inherit texlive-module
DESCRIPTION="TeXLive Czech/Slovak"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~x86"
