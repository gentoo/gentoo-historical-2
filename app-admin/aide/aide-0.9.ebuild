# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/aide/aide-0.9.ebuild,v 1.2 2002/10/29 13:55:56 aliz Exp $

IUSE="nls postgres zlib crypt"

S=${WORKDIR}/${P}
DESCRIPTION="AIDE (Advanced Intrusion Detection Environment) is a free replacement for Tripwire"
HOMEPAGE="http://www.cs.tut.fi/~rammer/aide.html"
SRC_URI="http://www.cs.tut.fi/~rammer/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64"

DEPEND="sys-apps/gzip 
	sys-devel/bison 
	sys-devel/flex
	dev-libs/libgcrypt
	app-crypt/mhash
	crypt? ( dev-libs/libgcrypt )
	postgres? ( dev-db/postgresql )"

RDEPEND=""

src_unpack() {
	unpack ${A}
	
	cd ${S}
	patch -p0 <${FILESDIR}/${PF}-gentoo.diff || die
}

src_compile() {

	local myconf
	use postgres && myconf="${myconf} --with-psql"
	use nls &&  myconf="${myconf} --with-locale"
	use zlib &&  myconf="${myconf} --with-zlib"
	use crypt &&  myconf="${myconf} --with-gcrypt"


	econf \
		--with-zlib \
		--sysconfdir=/etc/aide \
		--with-mhash \
		--with-extra-lib=/usr/lib \
		${myconf} || die
	
	emake || die
}

src_install() {

	make prefix=${D}/usr mandir=${D}/usr/share/man  install || die

	dodir /etc/aide
	cp doc/aide.conf ${D}/etc/aide

	dodoc AUTHORS COPYING INSTALL NEWS README 
	dohtml doc/manual.html

}
