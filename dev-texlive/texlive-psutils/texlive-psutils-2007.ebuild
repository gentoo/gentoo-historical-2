# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-psutils/texlive-psutils-2007.ebuild,v 1.4 2007/10/25 14:34:16 armin76 Exp $

TEXLIVE_MODULES_DEPS=""
TEXLIVE_MODULE_CONTENTS="bin-getafm bin-lcdftypetools bin-pstools bin-psutils bin-t1utils bin-ttf2pt1 dvipsconfig collection-psutils
"
inherit texlive-module
DESCRIPTION="TeXLive PostScript and Truetype utilities"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha ~ia64 ~sparc ~x86"
