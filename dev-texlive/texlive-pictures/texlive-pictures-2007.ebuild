# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-pictures/texlive-pictures-2007.ebuild,v 1.14 2008/04/16 15:01:04 pva Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="bardiag curve curve2e curves dcpic dottex dratex eepic gnuplottex miniplot pb-diagram petri-nets picinpar pict2e pictex pictex2 pmgraph randbild swimgraf texdraw xypic collection-pictures
"
inherit texlive-module
DESCRIPTION="TeXLive Packages for drawings graphics"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
