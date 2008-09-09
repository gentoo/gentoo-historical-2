# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-texinfo/texlive-texinfo-2008.ebuild,v 1.1 2008/09/09 16:54:25 aballier Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="texinfo collection-texinfo
"
TEXLIVE_MODULE_DOC_CONTENTS="texinfo.doc "
TEXLIVE_MODULE_SRC_CONTENTS=""
inherit texlive-module
DESCRIPTION="TeXLive GNU Texinfo"

LICENSE="GPL-2 GPL-1 "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
