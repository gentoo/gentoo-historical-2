# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdbg/kdbg-1.9.4.ebuild,v 1.4 2004/06/25 02:38:01 agriffis Exp $

inherit kde

DESCRIPTION="A Graphical Debugger Interface to gdb"
SRC_URI="mirror://sourceforge/kdbg/${P}.tar.gz"
HOMEPAGE="http://members.nextra.at/johsixt/kdbg.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"
IUSE=""

RDEPEND=">=sys-devel/gdb-5.0"
need-kde 3