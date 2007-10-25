# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-publishers/texlive-publishers-2007.ebuild,v 1.5 2007/10/25 15:50:03 corsair Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-latex
"
TEXLIVE_MODULE_CONTENTS="IEEEconf IEEEtran aastex acmconf acmtrans active-conf aguplus aiaa apa asaetr ascelike chem-journal ebsthesis economic elsevier gatech-thesis icsv ieeepes ifacmtg imac jhep jpsj kluwer mentis mnras muthesis nature nih nrc osa pracjourn procIAGssymp ptptex revtex sae siggraph spie stellenbosch sugconf thesis-titlepage-fhac tugboat uaclasses ucthesis uiucthesis umich-thesis uwthesis vancouver york-thesis collection-publishers
"
inherit texlive-module
DESCRIPTION="TeXLive Support for publishers"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha ~ia64 ~ppc64 ~sparc ~x86"
