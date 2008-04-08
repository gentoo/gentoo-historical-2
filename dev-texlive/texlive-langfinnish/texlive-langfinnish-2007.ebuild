# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langfinnish/texlive-langfinnish-2007.ebuild,v 1.13 2008/04/08 14:59:27 armin76 Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="finbib hyphen-finnish collection-langfinnish
"
inherit texlive-module
DESCRIPTION="TeXLive Finnish"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
