# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-genericextra/texlive-genericextra-2007.ebuild,v 1.12 2008/04/08 05:30:00 jer Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="abbr abstyles aurora barr borceux c-pascal colorsep dinat eijkhout fltpoint insbox mathdots metatex mftoeps midnight multi ofs pdf-trans psfig realcalc vrb vtex collection-genericextra
"
inherit texlive-module
DESCRIPTION="TeXLive Miscellaneous extra generic macros"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ia64 ~ppc ppc64 ~sparc x86 ~x86-fbsd"
