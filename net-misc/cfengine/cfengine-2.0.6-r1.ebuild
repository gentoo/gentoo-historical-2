# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cfengine/cfengine-2.0.6-r1.ebuild,v 1.2 2003/09/05 22:01:48 msterret Exp $

S=${WORKDIR}/${P}
DESCRIPTION="An agent/software robot and a high level policy language for building expert systems to administrate and configure large computer networks"
SRC_URI="ftp://ftp.iu.hio.no/pub/cfengine/${P}.tar.gz"
HOMEPAGE="http://www.iu.hio.no/cfengine/"

DEPEND="virtual/glibc
	>=sys-libs/db-3.2
	dev-libs/openssl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~ppc"

src_unpack(){
	unpack ${A}
	cd ${S}
	patch -p0 < ${FILESDIR}/${P}-db4.diff ||die
}

src_compile() {
	local myconf
	myconf="--with-berkeleydb=/usr"
	econf ${myconf} || die
	emake || die
}

src_install () {
	emake DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING DOCUMENTATION NEWS README SURVEY TODO
	dodoc doc/*.html
	doinfo doc/*.info*
	dodoc ${D}/usr/share/cfengine/*.example
	rm -rf ${D}/usr/share/cfengine ${D}/usr/doc
}
