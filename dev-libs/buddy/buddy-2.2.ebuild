# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/buddy/buddy-2.2.ebuild,v 1.3 2004/07/02 04:34:54 eradicator Exp $

DESCRIPTION="BuDDY - A Binary Decision Diagram Package"
HOMEPAGE="http://www.itu.dk/research/buddy/"
SRC_URI="http://www.itu.dk/research/buddy/buddy22.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND="virtual/libc"

S=${WORKDIR}/buddy22

src_compile() {
	make CFLAGS="${CFLAGS}" \
	LIBDIR=usr/lib \
	INCDIR=usr/include \
	|| die
}

src_install() {
	install -d ${D}/usr/lib ${D}/usr/include
	make install \
	LIBDIR=${D}/usr/lib \
	INCDIR=${D}/usr/include || die
	dodoc CHANGES README doc/*.txt
	insinto /usr/share/doc/${P}/ps
	doins doc/*.ps
	insinto /usr/share/${PN}/examples
	cd examples
	for example in *; do
		tar -czf ${example}.tar.gz ${example}
		doins ${example}.tar.gz
	done
}
