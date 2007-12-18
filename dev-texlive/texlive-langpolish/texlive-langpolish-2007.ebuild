# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langpolish/texlive-langpolish-2007.ebuild,v 1.7 2007/12/18 20:22:12 jer Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-latex
dev-texlive/texlive-fontsextra"
TEXLIVE_MODULE_CONTENTS="antp  bin-mex bin-platex cc-pl gustlib hyphen-polish  mex mwcls ogonek pl platex qfonts qpxqtx tap utf8mex collection-langpolish
"
inherit texlive-module
DESCRIPTION="TeXLive Polish"

LICENSE="GPL-2 LPPL-1.3c Aladdin"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~sparc ~x86"
