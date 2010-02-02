# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-korean/texlive-documentation-korean-2009.ebuild,v 1.2 2010/02/02 21:31:30 abcd Exp $

TEXLIVE_MODULE_CONTENTS="lshort-korean collection-documentation-korean
"
TEXLIVE_MODULE_DOC_CONTENTS="lshort-korean.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit texlive-module
DESCRIPTION="TeXLive Korean documentation"

LICENSE="GPL-2 FDL-1.1 "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2009
"
RDEPEND="${DEPEND} "
