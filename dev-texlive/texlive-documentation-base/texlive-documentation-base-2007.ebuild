# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-base/texlive-documentation-base-2007.ebuild,v 1.3 2007/10/25 12:46:03 fmccor Exp $

TEXLIVE_MODULES_DEPS=""
TEXLIVE_MODULE_CONTENTS="texlive-common texlive-en collection-documentation-base
"
inherit texlive-module
DESCRIPTION="TeXLive Base documentation"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~sparc ~x86"
