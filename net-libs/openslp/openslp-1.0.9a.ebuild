# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/openslp/openslp-1.0.9a.ebuild,v 1.2 2002/12/09 04:33:13 manson Exp $

DESCRIPTION="An open-source implementation of Service Location Protocol"
HOMEPAGE="http://www.openslp.org"

S=${WORKDIR}/${P}
SRC_URI="mirror://sourceforge/openslp/${P}.tar.gz"

KEYWORDS="x86 sparc  ppc"
DEPEND="virtual/glibc"

SLOT="0"
LICENSE="BSD"

src_compile() {
	econf || die
	make || die
}

src_install() {
	einstall || die
	dodoc AUTHORS FAQ COPYING ChangeLog NEWS README* THANKS
	rm -rf ${D}/usr/doc
	dohtml -r .
	exeinto /etc/init.d
	newexe ${FILESDIR}/slpd-init slpd
}
