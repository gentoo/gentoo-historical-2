# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kletterwizard/kletterwizard-0.9.4.ebuild,v 1.5 2005/01/14 23:35:16 danarmak Exp $

inherit kde

DESCRIPTION="KLetterWizard is a KDE application which simplifies letter writing and produces output via LaTeX."
HOMEPAGE="http://www.kluenter.de/klw.html"
SRC_URI="http://www.kluenter.de/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND="virtual/tetex
		>=dev-tex/g-brief-4.0.1
		|| ( kde-base/kdegraphics-meta >=kde-base/kdegraphics-3.2.0 )"
need-kde 3
