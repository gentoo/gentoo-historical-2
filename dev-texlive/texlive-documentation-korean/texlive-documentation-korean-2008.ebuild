# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-korean/texlive-documentation-korean-2008.ebuild,v 1.6 2009/03/10 19:12:56 armin76 Exp $

TEXLIVE_MODULE_CONTENTS="lshort-korean collection-documentation-korean
"
TEXLIVE_MODULE_DOC_CONTENTS="lshort-korean.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit texlive-module
DESCRIPTION="TeXLive Korean documentation"

LICENSE="GPL-2 freedist "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2008
"
RDEPEND="${DEPEND}"
