# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pmud/pmud-0.10.1-r3.ebuild,v 1.2 2004/03/04 11:21:10 vapier Exp $

inherit eutils

DESCRIPTION="PowerMac power management utilities"
HOMEPAGE="http://penguinppc.org/"
SRC_URI="http://linuxppc.jvc.nl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~ppc"
IUSE="X"

DEPEND="sys-kernel/linux-headers
	X? ( virtual/x11 )"
RDEPEND="sys-apps/util-linux"

S=${WORKDIR}/${PN}-0.10

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-deb-fcntl.patch
	epatch ${FILESDIR}/pmud-file-locations.patch
	use X || epatch ${FILESDIR}/pmud-makefile-x-gentoo.diff
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	doman pmud.8 snooze.8 fblevel.8
	into /
	dosbin pmud wakebay snooze fblevel || die "dosbin failed"
	exeinto /etc/power
	doexe ${FILESDIR}/pwrctl{,-local}
	exeinto /etc/init.d
	newexe ${FILESDIR}/pmud.start pmud
	insinto /etc
	doins ${FILESDIR}/power.conf
	if use X ; then
		doman batmon.8 xmouse.8
		into /usr
		dobin Batmon || die "Batmon failed"
		exeinto /usr/X11R6/bin
		doexe xmouse || die "xmouse failed"
	fi
}
