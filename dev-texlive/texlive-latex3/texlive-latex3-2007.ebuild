# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-latex3/texlive-latex3-2007.ebuild,v 1.2 2007/10/25 06:59:48 opfer Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-latex
"
TEXLIVE_MODULE_CONTENTS="galley template xinitials xor xparse xtab xtcapts xtheorem collection-latex3
"
inherit texlive-module
DESCRIPTION="TeXLive LaTeX3 packages"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~x86"
