# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-japanese/texlive-documentation-japanese-2008.ebuild,v 1.3 2009/02/27 15:12:07 fmccor Exp $

TEXLIVE_MODULE_CONTENTS="lshort-japanese collection-documentation-japanese
"
TEXLIVE_MODULE_DOC_CONTENTS="lshort-japanese.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit texlive-module
DESCRIPTION="TeXLive Japanese documentation"

LICENSE="GPL-2 GPL-1 "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 sparc ~x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2008
"
RDEPEND="${DEPEND}"
