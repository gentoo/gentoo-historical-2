# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/checkpassword/checkpassword-0.90.ebuild,v 1.7 2002/10/04 06:06:58 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A modern replacement for sendmail which uses maildirs"
SRC_URI="http://cr.yp.to/checkpwd/${P}.tar.gz"
HOMEPAGE="http://www.qmail.org/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ppc sparc sparc64"

src_compile() {
	cd ${S}
	echo "gcc ${CFLAGS}" > conf-cc
	make || die
}



src_install() {				 
	into /
	dobin checkpassword
	dodoc CHANGES README TODO VERSION
}
