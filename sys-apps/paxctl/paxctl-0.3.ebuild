# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/paxctl/paxctl-0.3.ebuild,v 1.4 2005/10/18 18:09:00 gustavoz Exp $

inherit flag-o-matic

DESCRIPTION="Manages various PaX related program header flags for Elf32, Elf64, binaries."
SRC_URI="http://pax.grsecurity.net/paxctl-${PV}.tar.gz"
HOMEPAGE="http://pax.grsecurity.net"
KEYWORDS="amd64 ~hppa ia64 ~mips ppc ~ppc64 sparc x86"
IUSE=""
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/libc >=sys-devel/binutils-2.14.90.0.8-r1"

#S=${WORKDIR}/${P}

src_compile() {
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	einstall DESTDIR="${D}"
	dodoc README ChangeLog
}
