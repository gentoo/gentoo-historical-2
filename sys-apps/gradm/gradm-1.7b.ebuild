# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gradm/gradm-1.7b.ebuild,v 1.1 2003/03/09 19:23:53 aliz Exp $

DESCRIPTION="ACL administrative interface to grsecurity"
SRC_URI="http://www.grsecurity.net/${P}.tar.gz"
HOMEPAGE="http://www.grsecurity.net/"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"

DEPEND="sys-devel/bison
	sys-devel/flex"
RDEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}

	cd ${S}
	cp ${FILESDIR}/${P}-chpax.c chpax.c

	mv Makefile{,.orig}
	sed -e "s|-O2|${CFLAGS}|" Makefile.orig > Makefile
}

src_compile() {
	emake CC="${CC}" || die "compile problem"
	emake CC="${CC}" chpax || die "compile problem"
}

src_install() {
	doman gradm.8
	dodoc acl
	exeinto /etc/init.d
	newexe ${FILESDIR}/grsecurity.rc grsecurity
	insinto /etc/conf.d
	doins ${FILESDIR}/grsecurity
	into /
	dosbin gradm chpax
	fperms 700 /sbin/gradm
	fperms 700 /sbin/chpax
}
