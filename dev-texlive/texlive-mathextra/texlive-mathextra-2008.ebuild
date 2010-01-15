# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-mathextra/texlive-mathextra-2008.ebuild,v 1.12 2010/01/15 10:34:10 grobian Exp $

TEXLIVE_MODULE_CONTENTS="12many amstex boldtensors ccfonts commath concmath concrete eqnarray extarrows extpfeil faktor mathcomp mhequ nath proba statex2 stex stmaryrd susy synproof tablor tensor turnstile venn yhmath bin-amstex collection-mathextra
"
TEXLIVE_MODULE_DOC_CONTENTS="12many.doc amstex.doc boldtensors.doc ccfonts.doc commath.doc concmath.doc concrete.doc eqnarray.doc extarrows.doc extpfeil.doc faktor.doc mhequ.doc nath.doc proba.doc stex.doc stmaryrd.doc susy.doc synproof.doc tablor.doc tensor.doc turnstile.doc venn.doc yhmath.doc bin-amstex.doc "
TEXLIVE_MODULE_SRC_CONTENTS="12many.source ccfonts.source concmath.source eqnarray.source extpfeil.source faktor.source mathcomp.source proba.source stex.source stmaryrd.source tensor.source turnstile.source yhmath.source "
inherit texlive-module
DESCRIPTION="TeXLive Advanced math typesetting"

LICENSE="GPL-2 as-is freedist GPL-1 LPPL-1.3 TeX "
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""
DEPEND=">=dev-texlive/texlive-fontsrecommended-2008
>=dev-texlive/texlive-latex-2008
"
RDEPEND="${DEPEND}"
