# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/gradm/gradm-1.9.13.ebuild,v 1.1 2003/12/01 22:56:00 solar Exp $

DESCRIPTION="Administrative interface for grsecurity ${PV} access control lists"
SRC_URI="http://www.grsecurity.net/${P}.tar.gz"
HOMEPAGE="http://www.grsecurity.net/"

LICENSE="GPL-2"
KEYWORDS="x86 amd64 sparc ~ppc hppa"
SLOT="0"

IUSE=""
DEPEND="virtual/glibc
	sys-devel/bison
	sys-devel/flex
	sys-apps/chpax"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/gradm_parse.c-1.9.x.patch
	mv Makefile{,.orig}
	sed -e "s|-O2|${CFLAGS}|" Makefile.orig > Makefile
}

src_compile() {
	emake CC="${CC}" || die "compile problem"
}

src_install() {
	doman gradm.8
	dodoc acl
	exeinto /etc/init.d
	newexe ${FILESDIR}/grsecurity.rc grsecurity
	insinto /etc/conf.d
	doins ${FILESDIR}/grsecurity
	into /
	dosbin gradm
	fperms 700 /sbin/gradm
}
