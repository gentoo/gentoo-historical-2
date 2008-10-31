# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-pictures/texlive-pictures-2008.ebuild,v 1.2 2008/10/31 14:45:46 aballier Exp $

TEXLIVE_MODULE_CONTENTS="autoarea bardiag curve curve2e curves dcpic dottex dratex eepic epspdf epspdfconversion gnuplottex miniplot pb-diagram petri-nets  pgf-soroban pgfopts pgfplots picinpar pict2e pictex pictex2 pinlabel pmgraph randbild swimgraf texdraw tikz-inet tufte-latex xypic collection-pictures
"
TEXLIVE_MODULE_DOC_CONTENTS="autoarea.doc bardiag.doc curve.doc curve2e.doc curves.doc dcpic.doc dottex.doc dratex.doc eepic.doc epspdf.doc epspdfconversion.doc gnuplottex.doc miniplot.doc pb-diagram.doc petri-nets.doc pgf-soroban.doc pgfopts.doc pgfplots.doc picinpar.doc pict2e.doc pictex.doc pinlabel.doc pmgraph.doc randbild.doc swimgraf.doc texdraw.doc tikz-inet.doc tufte-latex.doc xypic.doc "
TEXLIVE_MODULE_SRC_CONTENTS="curve.source curve2e.source curves.source dottex.source gnuplottex.source petri-nets.source pgfopts.source pgfplots.source pict2e.source randbild.source swimgraf.source xypic.source "
inherit texlive-module
DESCRIPTION="TeXLive Graphics packages"

LICENSE="GPL-2 Apache-2.0 as-is freedist GPL-1 LPPL-1.3 "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2008
"
RDEPEND="${DEPEND}"
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/epspdf/epspdf texmf-dist/scripts/epspdf/epspdftk"
