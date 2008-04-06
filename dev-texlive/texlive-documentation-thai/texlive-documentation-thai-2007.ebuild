# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-thai/texlive-documentation-thai-2007.ebuild,v 1.10 2008/04/06 15:09:33 corsair Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-documentation-base
"
TEXLIVE_MODULE_CONTENTS="lshort-thai collection-documentation-thai
"
inherit texlive-module
DESCRIPTION="TeXLive Thai documentation"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ppc64 ~sparc x86 ~x86-fbsd"
