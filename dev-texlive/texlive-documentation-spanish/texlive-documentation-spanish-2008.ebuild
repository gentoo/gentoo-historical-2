# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-spanish/texlive-documentation-spanish-2008.ebuild,v 1.2 2008/10/31 14:21:46 aballier Exp $

TEXLIVE_MODULE_CONTENTS="es-tex-faq l2tabu-spanish lshort-spanish collection-documentation-spanish
"
TEXLIVE_MODULE_DOC_CONTENTS="es-tex-faq.doc l2tabu-spanish.doc lshort-spanish.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit texlive-module
DESCRIPTION="TeXLive Spanish documentation"

LICENSE="GPL-2 as-is public-domain "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-documentation-base-2008
"
RDEPEND="${DEPEND}"
