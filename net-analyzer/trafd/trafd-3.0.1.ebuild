# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/trafd/trafd-3.0.1.ebuild,v 1.1 2002/11/08 13:07:26 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The BPF Traffic Collector"
SRC_URI="ftp://ftp.riss-telecom.ru/pub/dev/trafd/${P}.tgz 
	http://metalab.unc.edu/pub/Linux/system/network/management/tcpdump-richard-1.7.tar.gz"
HOMEPAGE="ftp://ftp.riss-telecom.ru/pub/dev/trafd/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"

# -lbpft/*����*/ -lpcap -lcurses -ltermcap -lfl
DEPEND="net-libs/libpcap
	sys-libs/ncurses
	sys-devel/flex"

RDEPEND=$DEPEND

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff

	mv Makefile Makefile.orig
	sed "44s/-O2$/${CFLAGS}/" Makefile.orig >Makefile
}

src_compile() {
	emake || die 
}

src_install () {
	dodir /usr/bin /etc /usr/share/doc/trafd-3.0.1 /var/trafd
	make install DESTDIR=${D} || die
	exeinto /etc/init.d ; newexe ${FILESDIR}/trafd.init trafd
	insinto /etc/conf.d ; newins ${FILESDIR}/trafd.conf trafd
}

pkg_postinst() {
    ewarn "NOTE: if you want to run trafd on boot then execute"
    ewarn "rc-update add trafd default"
    ewarn "change interfaces in /etc/conf.d/trafd (default is eth0)"
}
