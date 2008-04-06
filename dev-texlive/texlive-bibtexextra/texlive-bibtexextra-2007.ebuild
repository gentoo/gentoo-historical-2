# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-bibtexextra/texlive-bibtexextra-2007.ebuild,v 1.10 2008/04/06 16:43:35 corsair Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-latex
"
TEXLIVE_MODULE_CONTENTS="apacite beebe bibarts bibhtml biblist bibtopic bibunits compactbib custom-bib doipubmed elsevier-bib footbib harvard harvmac ijqc inlinebib iopart-num jneurosci jurabib listbib multibib munich perception rsc sort-by-letters urlbst collection-bibtexextra
"
inherit texlive-module
DESCRIPTION="TeXLive Extra BibTeX styles"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ppc64 ~sparc x86 ~x86-fbsd"
