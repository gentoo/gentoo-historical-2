# Copyright 2000-2002 Achim Gottinger
# Distributed under the GPL by Gentoo Technologies, Inc.
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nessus-plugins/nessus-plugins-1.2.6.ebuild,v 1.2 2002/12/09 04:33:08 manson Exp $

S=${WORKDIR}/${PN}

DESCRIPTION="A remote security scanner for Linux (nessus-plugins)"
HOMEPAGE="http://www.nessus.org/"
SRC_URI="ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/${P}.tar.gz"

DEPEND="=net-analyzer/nessus-core-${PV}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc -sparc "

src_compile() {

	econf || die "configure failed"

	emake || die "emake failed"

}

src_install() {

	make \
		prefix=${D}/usr \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		mandir=${D}/usr/share/man \
		install || die "make install failed"

	cd ${S}
	docinto nessus-plugins
	dodoc docs/*.txt plugins/accounts/accounts.txt

}
