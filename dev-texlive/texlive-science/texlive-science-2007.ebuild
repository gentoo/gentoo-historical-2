# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-science/texlive-science-2007.ebuild,v 1.13 2008/04/08 14:59:22 armin76 Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-latex
!dev-tex/SIunits"
TEXLIVE_MODULE_CONTENTS="SIstyle SIunits alg algorithm2e algorithmicx algorithms biocon bitfield bpchem bytefield chemarrow chemcompounds chemcono clrscode complexity computational-complexity digiconfigs dyntree formula functan galois gastex hepparticles hepthesis hepunits karnaugh mhchem mhs miller newalg objectz pseudocode scientificpaper sciposter struktex t-angles textopo unitsdef youngtab collection-science
"
inherit texlive-module
DESCRIPTION="TeXLive Typesetting for natural and computer sciences"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
