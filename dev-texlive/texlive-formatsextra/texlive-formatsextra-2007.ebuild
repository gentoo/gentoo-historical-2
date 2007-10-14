# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-formatsextra/texlive-formatsextra-2007.ebuild,v 1.1 2007/10/14 08:31:59 aballier Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="alatex bin-eplain bin-mltex bin-physe bin-phyzzx bin-texsis edmac eplain mltex physe phyzzx psizzl startex texsis ytex collection-formatsextra
"
inherit texlive-module
DESCRIPTION="TeXLive Extra formats"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS=""
