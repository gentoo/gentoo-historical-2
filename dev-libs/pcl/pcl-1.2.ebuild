# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pcl/pcl-1.2.ebuild,v 1.1 2003/11/04 14:01:45 klieber Exp $  

DESCRIPTION="A library to provide low-level coroutines for in-process context switching"
HOMEPAGE="http://www.xmailserver.org/libpcl.html"
SRC_URI="http://monkey.org/~provos/${P}.tar.gz"
SRC_URI="http://www.xmailserver.org/${P}.tar.gz"
S=${WORKDIR}/${P}

# unsure on this one
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_compile() {
	econf || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	dolib pcl/libpcl.a
	dodoc ChangeLog INSTALL NEWS README
	dohtml man/pcl.html
	doman man/pcl.3
	insinto /usr/include
	doins include/pcl.h
}
