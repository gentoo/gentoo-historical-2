# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/redir/redir-2.2.1.ebuild,v 1.1 2003/09/19 13:46:58 hhg Exp $ 

DESCRIPTION="Redir is a port redirector."
HOMEPAGE="http://sammy.net/~sammy/hacks/"
SRC_URI="http://sammy.net/~sammy/hacks/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~alpha ~arm ~hppa ~mips ~sparc"
IUSE=""
DEPEND=""
RDEPEND=""

src_compile() {
	emake || die
}

src_install() {
	dobin redir
	newman redir.man redir.1
	dodoc CHANGES COPYING README transproxy.txt
}
