# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langhungarian/texlive-langhungarian-2007.ebuild,v 1.5 2007/10/25 16:18:20 corsair Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="hyphen-hungarian magyar collection-langhungarian
"
inherit texlive-module
DESCRIPTION="TeXLive Hungarian"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha ~ia64 ~ppc64 ~sparc ~x86"
