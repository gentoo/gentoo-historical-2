# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/kile/kile-1.5.2.ebuild,v 1.3 2003/10/31 21:12:57 usata Exp $
inherit kde-base

need-kde 3.1

IUSE=""
DESCRIPTION="A Latex Editor and TeX shell for kde"
SRC_URI="mirror://sourceforge/kile/${P}.tar.gz"
HOMEPAGE="http://kile.sourceforge.net"

DEPEND="$DEPEND dev-lang/perl"
RDEPEND="${RDEPEND} virtual/tetex"

KEYWORDS="x86"
LICENSE="GPL-2"
