# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rp-l2tp/rp-l2tp-0.3-r1.ebuild,v 1.3 2003/07/18 20:59:07 tester Exp $

inherit eutils

DESCRIPTION="RP-L2TP is a user-space implementation of L2TP for Linux and other UNIX systems"
HOMEPAGE="http://sourceforge.net/projects/rp-l2tp/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-gentoo.diff.bz2"
DEPEND="virtual/glibc"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SLOT="0"
IUSE=""

src_unpack() {
	unpack ${A} || die
	cd ${S} || die
	epatch ../${P}-gentoo.diff
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make RPM_INSTALL_ROOT=${D} install || die

	dodoc README
	newdoc l2tp.conf rp-l2tpd.conf
	cp -a libevent/Doc ${D}/usr/share/doc/${PF}/libevent

	exeinto /etc/init.d
	newexe ${FILESDIR}/rp-l2tpd-init rp-l2tpd
}
