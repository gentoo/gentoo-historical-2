# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xapian/xapian-0.5.5.ebuild,v 1.5 2004/07/02 04:57:10 eradicator Exp $

IUSE=""

S=${WORKDIR}/xapian-core-${PV}
DESCRIPTION="Xapian Probabilistic Information Retrieval library"
SRC_URI="http://www.tartarus.org/~olly/xapian-0.5.5/xapian-core-${PV}.tar.gz"
HOMEPAGE="http://www.xapian.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/libc"

src_compile() {
	econf || die "./configure failed"
	emake || die
}

src_install () {
	einstall || die
	dodoc AUTHORS COPYING HACKING INSTALL PLATFORMS README TODO
	#docs tly et installed under /usr/share/xapian, lets move them under /usr/share/doc..
	cd ${D}/usr/share/${PN}
	dodir /usr/share/doc/${PF}/html
	mv *.html apidoc/ ${D}/usr/share/doc/${PF}/html
	mv * ${D}/usr/share/doc/${PF}
	rmdir ${D}/usr/share/${PN}
}
