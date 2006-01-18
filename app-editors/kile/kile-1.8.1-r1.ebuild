# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/kile/kile-1.8.1-r1.ebuild,v 1.6 2006/01/18 19:32:34 corsair Exp $

inherit kde

DESCRIPTION="A Latex Editor and TeX shell for kde"
HOMEPAGE="http://kile.sourceforge.net/"
SRC_URI="mirror://sourceforge/kile/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT=0
KEYWORDS="amd64 ppc ~ppc64 sparc x86"
IUSE="kde"

RDEPEND="dev-lang/perl
	virtual/tetex
	kde? ( || ( ( kde-base/kpdf
	              kde-base/kghostview
	              kde-base/kdvi
	              kde-base/kviewshell )
	            kde-base/kdegraphics ) )"

need-kde 3.2
