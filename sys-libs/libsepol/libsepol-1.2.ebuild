# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libsepol/libsepol-1.2.ebuild,v 1.3 2005/01/08 03:08:33 pebenito Exp $

IUSE="mls"

DESCRIPTION="SELinux binary policy management library"
HOMEPAGE="http://www.nsa.gov/selinux"
SRC_URI="http://www.nsa.gov/selinux/archives/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}

	cd ${S}

	if use mls; then
		sed -i -e '/^MLS/s/n/y/' src/Makefile \
			|| die "MLS option failed."
	fi

	sed -i -e "s:-Wall:-Wall ${CFLAGS}:g" src/Makefile \
		|| die "src Makefile CFLAGS fix failed."
	sed -i -e "s:-Wall:-Wall ${CFLAGS}:g" utils/Makefile \
		|| die "utils Makefile CFLAGS fix failed."
}

src_compile() {
	emake || die
}

src_install() {
	make DESTDIR="${D}" install
}
