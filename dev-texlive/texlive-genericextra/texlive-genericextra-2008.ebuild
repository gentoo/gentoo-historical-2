# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-genericextra/texlive-genericextra-2008.ebuild,v 1.11 2009/06/10 14:06:11 alexxy Exp $

TEXLIVE_MODULE_CONTENTS="abbr abstyles barr borceux c-pascal colorsep dinat eijkhout encxvlna fenixpar fltpoint insbox mathdots metatex mftoeps midnight multi ofs pdf-trans vrb vtex collection-genericextra
"
TEXLIVE_MODULE_DOC_CONTENTS="abbr.doc abstyles.doc barr.doc borceux.doc c-pascal.doc dinat.doc encxvlna.doc fenixpar.doc fltpoint.doc insbox.doc mathdots.doc metatex.doc midnight.doc ofs.doc pdf-trans.doc vrb.doc "
TEXLIVE_MODULE_SRC_CONTENTS="borceux.source fltpoint.source mathdots.source mftoeps.source "
inherit texlive-module
DESCRIPTION="TeXLive Extra generic packages"

LICENSE="GPL-2 as-is freedist LPPL-1.3 public-domain TeX "
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2008
"
RDEPEND="${DEPEND}"
