# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/schedutils/schedutils-1.3.0.ebuild,v 1.3 2004/06/24 22:25:40 agriffis Exp $

DESCRIPTION="Utilities for manipulating kernel schedular parameters"
HOMEPAGE="http://tech9.net/rml/schedutils"
KEYWORDS="~x86 ~amd64 ~ppc"
LICENSE="GPL-2"

RDEPEND="virtual/glibc"
DEPEND="$RDEPEND
	>=sys-apps/sed-4"
SLOT="0"

SRC_URI="http://tech9.net/rml/${PN}/packages/${PV}/${P}.tar.gz"
S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's:\(#include <features.h>\):\1\n#include <errno.h>:' \
		taskset.c || die "Sed failed"
}

src_compile() {
	emake PREFIX=/usr || die "Make failed"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	dodir /usr/share/doc
	einstall PREFIX=${D}/usr || die "Install failed"
}
