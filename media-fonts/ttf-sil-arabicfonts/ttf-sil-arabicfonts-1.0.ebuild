# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/ttf-sil-arabicfonts/ttf-sil-arabicfonts-1.0.ebuild,v 1.12 2008/01/20 14:17:13 ranger Exp $

inherit font

DESCRIPTION="SIL Arabic Script - SIL fonts for Arabic Languages"
HOMEPAGE="http://scripts.sil.org/ArabicFonts"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="SIL-freeware"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ppc ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

DOCS=""
FONT_SUFFIX="ttf"

FONT_S="${S}"
