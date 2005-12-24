# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/autossh/autossh-1.3.ebuild,v 1.1 2005/12/24 18:21:20 vanquirius Exp $

inherit toolchain-funcs

DESCRIPTION="Automatically restart SSH sessions and tunnels"
HOMEPAGE="http://www.harding.motd.ca/autossh/"
LICENSE="BSD"
KEYWORDS="~x86 ~sparc ~alpha ~ia64 ~amd64 ~ppc"
SRC_URI="http://www.harding.motd.ca/autossh/${P}.tgz"
SLOT="0"
IUSE=""

DEPEND="virtual/libc
	sys-apps/sed"
RDEPEND="virtual/libc
	net-misc/openssh"

src_unpack() {
	unpack ${A} && cd "${S}"
	sed -i "s|CFLAGS=|CFLAGS=${CFLAGS}|g" Makefile.linux
}

src_compile() {
	export CC="$(tc-getCC)"
	emake -f Makefile.linux || die "make failed"
}

src_install() {
	dobin autossh
	dodoc CHANGES README autossh.host rscreen
	doman autossh.1
}
