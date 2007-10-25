# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langcjk/texlive-langcjk-2007.ebuild,v 1.3 2007/10/25 12:46:15 fmccor Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
dev-texlive/texlive-documentation-chinese
"
TEXLIVE_MODULE_CONTENTS="CJK arphic bin-cjkutils c90enc cns garuda hyphen-pinyin norasi uhc wadalab yi4latex collection-langcjk
"
inherit texlive-module
DESCRIPTION="TeXLive Chinese, Japanese, Korean"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~sparc ~x86"
