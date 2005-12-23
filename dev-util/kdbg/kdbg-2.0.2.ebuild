# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdbg/kdbg-2.0.2.ebuild,v 1.2 2005/12/23 10:44:25 corsair Exp $

inherit kde

DESCRIPTION="A Graphical Debugger Interface to gdb"
HOMEPAGE="http://members.nextra.at/johsixt/kdbg.html"
SRC_URI="mirror://sourceforge/kdbg/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=sys-devel/gdb-5.0"

need-kde 3
