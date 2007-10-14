# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-greek/texlive-documentation-greek-2007.ebuild,v 1.1 2007/10/14 10:16:33 aballier Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-documentation-base
"
TEXLIVE_MODULE_CONTENTS="gentle-gr collection-documentation-greek
"
inherit texlive-module
DESCRIPTION="TeXLive Greek documentation"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS=""
