# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-genericrecommended/texlive-genericrecommended-2008.ebuild,v 1.5 2009/03/07 10:59:35 fauli Exp $

TEXLIVE_MODULE_CONTENTS="epsf fontname genmisc multido tex-ps collection-genericrecommended
"
TEXLIVE_MODULE_DOC_CONTENTS="epsf.doc fontname.doc multido.doc tex-ps.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit texlive-module
DESCRIPTION="TeXLive Recommended generic packages"

LICENSE="GPL-2 GPL-1 LPPL-1.3 public-domain "
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2008
!=dev-texlive/texlive-basic-2007*
"
RDEPEND="${DEPEND}"
