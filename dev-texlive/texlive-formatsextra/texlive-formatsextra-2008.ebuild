# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-formatsextra/texlive-formatsextra-2008.ebuild,v 1.11 2009/06/10 14:05:26 alexxy Exp $

TEXLIVE_MODULE_CONTENTS="alatex edmac eplain mltex physe phyzzx psizzl startex texsis ytex bin-eplain bin-mltex bin-physe bin-phyzzx bin-texsis collection-formatsextra
"
TEXLIVE_MODULE_DOC_CONTENTS="alatex.doc edmac.doc eplain.doc mltex.doc phyzzx.doc psizzl.doc startex.doc texsis.doc bin-eplain.doc "
TEXLIVE_MODULE_SRC_CONTENTS="alatex.source edmac.source eplain.source psizzl.source startex.source "
inherit texlive-module
DESCRIPTION="TeXLive Extra formats"

LICENSE="GPL-2 as-is freedist GPL-1 LPPL-1.3 TeX "
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2008
>=dev-texlive/texlive-latex-2008
"
RDEPEND="${DEPEND}"
