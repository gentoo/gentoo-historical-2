# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/dd-rescue/dd-rescue-1.02.ebuild,v 1.2 2004/06/04 23:30:36 dholm Exp $

IUSE=""

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}

S=${WORKDIR}/${MY_PN}
DESCRIPTION="similar to dd but can copy from source with errors"
HOMEPAGE="http://www.garloff.de/kurt/linux/ddrescue/"
SRC_URI="http://www.garloff.de/kurt/linux/ddrescue/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 sparc"


src_unpack() {
	unpack ${A}
	cd ${S}
	mv Makefile Makefile.orig
	sed -e "s:^CFLAGS.*:CFLAGS = ${CFLAGS}:" \
		Makefile.orig > Makefile
}

src_compile() {
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc COPYING README.dd_rescue
}

