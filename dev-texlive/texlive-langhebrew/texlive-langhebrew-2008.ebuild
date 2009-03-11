# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langhebrew/texlive-langhebrew-2008.ebuild,v 1.7 2009/03/11 23:00:49 maekke Exp $

TEXLIVE_MODULE_CONTENTS="cjhebrew collection-langhebrew
"
TEXLIVE_MODULE_DOC_CONTENTS="cjhebrew.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit texlive-module
DESCRIPTION="TeXLive Hebrew"

LICENSE="GPL-2 "
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2008
"
RDEPEND="${DEPEND}"
