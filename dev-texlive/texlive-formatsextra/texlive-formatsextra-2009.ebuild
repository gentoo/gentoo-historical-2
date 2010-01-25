# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-formatsextra/texlive-formatsextra-2009.ebuild,v 1.3 2010/01/25 14:05:04 aballier Exp $

TEXLIVE_MODULE_CONTENTS="alatex edmac eplain mltex physe phyzzx psizzl startex texsis ytex collection-formatsextra
"
TEXLIVE_MODULE_DOC_CONTENTS="alatex.doc edmac.doc eplain.doc mltex.doc phyzzx.doc psizzl.doc startex.doc texsis.doc "
TEXLIVE_MODULE_SRC_CONTENTS="alatex.source edmac.source eplain.source psizzl.source startex.source "
inherit texlive-module
DESCRIPTION="TeXLive Extra formats"

LICENSE="GPL-2 as-is GPL-1 LPPL-1.3 public-domain TeX "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2009
>=dev-texlive/texlive-latex-2008
"
RDEPEND="${DEPEND} "
