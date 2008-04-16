# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langafrican/texlive-langafrican-2007.ebuild,v 1.14 2008/04/16 14:37:40 pva Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="ethiop ethiop-t1 fc collection-langafrican
"
inherit texlive-module
DESCRIPTION="TeXLive African scripts"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
