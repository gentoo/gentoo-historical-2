# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/kile/kile-1.6.3.ebuild,v 1.5 2004/07/03 21:35:08 carlo Exp $

inherit kde

DESCRIPTION="A Latex Editor and TeX shell for kde"
SRC_URI="mirror://sourceforge/kile/${P}.tar.gz"
HOMEPAGE="http://kile.sourceforge.net"

IUSE=""
SLOT=0

KEYWORDS="x86 amd64 ~sparc ~ppc"
LICENSE="GPL-2"

DEPEND="dev-lang/perl"
RDEPEND="virtual/tetex"
need-kde 3.1
