# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netselect/netselect-0.3.ebuild,v 1.16 2004/05/26 19:39:27 vapier Exp $

DESCRIPTION="Ultrafast implementation of ping."
HOMEPAGE="http://www.worldvisions.ca/~apenwarr/netselect/"
SRC_URI="http://www.worldvisions.ca/~apenwarr/netselect/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64 ppc64 s390"
IUSE=""

S=${WORKDIR}/${PN}

src_compile() {
	sed -i \
		-e "s:PREFIX =.*:PREFIX = ${D}usr:" \
		-e "s:CFLAGS =.*:CFLAGS = -Wall -I. -g ${CFLAGS}:" \
		-e '23,27d' \
		-e '34d' \
		Makefile
	make || die
}

src_install() {
	make install || die
	dodoc ChangeLog HISTORY README*
}
