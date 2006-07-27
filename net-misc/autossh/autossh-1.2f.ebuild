# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/autossh/autossh-1.2f.ebuild,v 1.10 2006/07/27 06:26:51 wormo Exp $

DESCRIPTION="Automatically restart SSH sessions and tunnels"
HOMEPAGE="http://www.harding.motd.ca/autossh/"
LICENSE="BSD"
KEYWORDS="x86 ~sparc alpha ~ia64 amd64 ~ppc"
SRC_URI="http://www.harding.motd.ca/autossh/${P}.tgz"
SLOT="0"
IUSE=""

DEPEND="virtual/libc sys-apps/sed"
RDEPEND="virtual/libc net-misc/openssh"

src_unpack() {
	unpack ${A} && cd ${S}
	sed -i "s|CFLAGS=|CFLAGS=${CFLAGS}|g" Makefile.linux
}

src_compile() {
	emake -f Makefile.linux || die "make failed"
}

src_install() {
	dobin autossh
	dodoc CHANGES README autossh.host rscreen
	doman autossh.1
}
