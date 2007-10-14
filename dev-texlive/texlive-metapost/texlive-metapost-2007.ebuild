# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-metapost/texlive-metapost-2007.ebuild,v 1.1 2007/10/14 08:22:11 aballier Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="bin-metapost cmarrows emp expressg exteps featpost feynmf hatching latexmp metaobj metaplot metapost metauml mfpic mp3d mpattern piechartmp roex slideshow splines textpath collection-metapost
"
inherit texlive-module
DESCRIPTION="TeXLive MetaPost (and Metafont) drawing packages"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS=""
