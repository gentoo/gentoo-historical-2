# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sslwrap/sslwrap-2.0.6.ebuild,v 1.7 2003/11/30 05:41:15 vapier Exp $

DESCRIPTION="TSL/SSL - Port Wrapper"
HOMEPAGE="http://quiltaholic.com/rickk/sslwrap/"
SRC_URI="http://quiltaholic.com/rickk/sslwrap/${PN}${PV/.0./0}.tar.gz
	mirror://gentoo/${PN}-gentoo.tar.bz2"

LICENSE="sslwrap"
SLOT="0"
KEYWORDS="x86 sparc"

DEPEND=">=dev-libs/openssl-0.9.6"

S=${WORKDIR}/${PN}${PV//.}

src_unpack () {
	unpack ${A}
	cd ${S}
	sed -i \
		-e "s:-O2:${CFLAGS}:" \
		-e "s:/usr/local/ssl/include:/usr/include/openssl:" \
		Makefile

	cp ${WORKDIR}/${PN}-gentoo/*.c ${S}
	has_version '=dev-libs/openssl-0.9.7*' \
		&& epatch ${FILESDIR}/${PV}-openssl-0.9.7.patch
	sed -i \
		-e "s:OPENSSL\":\"openssl\/:g" \
		*.h *.c
}

src_compile() {
	emake || die
}

src_install() {
	cd ${S}
	into /usr
	dosbin sslwrap
	dodoc README
	dohtml -r ./
}
