# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/openslp/openslp-1.0.9a.ebuild,v 1.7 2004/06/24 23:17:21 agriffis Exp $

DESCRIPTION="An open-source implementation of Service Location Protocol"
HOMEPAGE="http://www.openslp.org"

S=${WORKDIR}/${P}
SRC_URI="mirror://sourceforge/openslp/${P}.tar.gz"

KEYWORDS="x86 sparc ppc hppa"
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
