# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langspanish/texlive-langspanish-2008.ebuild,v 1.2 2008/10/31 14:39:02 aballier Exp $

TEXLIVE_MODULE_CONTENTS="hyphen-spanish hyphen-catalan hyphen-galician spanish-mx collection-langspanish
"
TEXLIVE_MODULE_DOC_CONTENTS="spanish-mx.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit texlive-module
DESCRIPTION="TeXLive Spanish"

LICENSE="GPL-2 LPPL-1.3 "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2008
"
RDEPEND="${DEPEND}"
