# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sysvinit/sysvinit-2.83-r1.ebuild,v 1.14 2004/07/15 02:38:23 agriffis Exp $

S=${WORKDIR}/${P}/src
DESCRIPTION="System initialization stuff"
HOMEPAGE="http://freshmeat.net/projects/sysvinit/"
SRC_URI="ftp://metalab.unc.edu/pub/Linux/system/daemons/init/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ppc sparc "
IUSE=""

RDEPEND="sys-apps/file"

src_unpack() {
	unpack ${A}
	cd ${S}
	mv Makefile Makefile.orig
	sed -e "s:-O2:${CFLAGS}:" Makefile.orig > Makefile
}

src_compile() {
	emake LDFLAGS="" || die "problem compiling"
}

src_install() {
	into /
	newsbin init init.system
	dosbin halt killall5 runlevel shutdown sulogin
	dosym init /sbin/telinit
	dobin last mesg utmpdump wall
	dosym killall5 /sbin/pidof
	dosym halt /sbin/reboot

	cd ${S}/../
	doman man/*.[1-9]

	dodoc COPYRIGHT README doc/*
}

pkg_postinst() {
	if [ ! -e ${ROOT}sbin/init ]
	then
		cp -a ${ROOT}sbin/init.system ${ROOT}sbin/init
	fi
}
