# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-english/texlive-documentation-english-2007.ebuild,v 1.5 2007/10/25 16:08:40 corsair Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-documentation-base
"
TEXLIVE_MODULE_CONTENTS="FAQ-en MemoirChapStyles Type1fonts amslatex-primer catalogue components-of-TeX comprehensive dtxtut firststeps free-math-font-survey gentle guide-to-latex help impatient knuth l2tabu-english latex-graphics-companion latex-web-companion latex2e-html lshort-english make-tex-work math-into-latex mathmode metafont-for-beginners metafp metapost-examples pstricks-tutorial tamethebeast tds tex-refs tlc2 truetype visualfaq webguide wp-conv collection-documentation-english
"
inherit texlive-module
DESCRIPTION="TeXLive English documentation"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha ~ia64 ~ppc64 ~sparc ~x86"
