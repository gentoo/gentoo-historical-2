# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/trickle/trickle-1.06.ebuild,v 1.4 2004/07/01 22:05:21 squinky86 Exp $

DESCRIPTION="a portable lightweight userspace bandwidth shaper"
SRC_URI="http://www.monkey.org/~marius/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.monkey.org/~marius/trickle/"

KEYWORDS="~x86"
SLOT="0"
LICENSE="BSD"
IUSE=""

DEPEND="virtual/libc
	dev-libs/libevent
	sys-apps/sed"
RDEPEND="virtual/libc"

src_compile() {
	econf || die "econf failed"
	make PREFIX=/usr || die
}

src_install() {
	einstall || die
}
