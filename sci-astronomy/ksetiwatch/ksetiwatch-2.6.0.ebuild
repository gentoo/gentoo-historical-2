# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/ksetiwatch/ksetiwatch-2.6.0.ebuild,v 1.1 2004/12/24 03:49:36 ribosome Exp $

inherit kde

DESCRIPTION="A monitoring tool for SETI@home, similar to SETIWatch for Windows"
HOMEPAGE="http://ksetiwatch.sourceforge.net"
SRC_URI="mirror://sourceforge/ksetiwatch/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="app-sci/setiathome"
need-kde 3

