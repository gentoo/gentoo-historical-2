# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/watchdog/watchdog-5.2.ebuild,v 1.10 2002/10/29 16:48:49 raker Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="A software watchdog."
HOMEPAGE="http://www.ibiblio.org/pub/Linux/system/daemons/watchdog/"
SRC_URI="http://www.ibiblio.org/pub/Linux/system/daemons/watchdog/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -ppc"
DEPEND="virtual/glibc"

src_unpack() {

	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/sundries.diff || die "patch failed"

}

src_compile() {
	# Two configure switches have been added to use /etc/watchdog
	econf \
		--sysconfdir=/etc/watchdog \
		--with-configfile=/etc/watchdog/watchdog.conf \
		|| die "./configure failed"

	emake || die
}

src_install () {
	dodir /etc/watchdog
	make DESTDIR="${D}" install || die

	exeinto /etc/init.d
	doexe "${FILESDIR}/${PVR}/watchdog"
}

pkg_postinst () {
	einfo
	einfo "To enable the start-up script run \"rc-update add watchdog boot\"."
	einfo
	if [ ! -e /dev/watchdog ]
	then
		ewarn
		ewarn "No /dev/watchdog found! Make sure your kernel has watchdog support"
		ewarn "compiled in or the kernel module is loaded. The watchdog service"
		ewarn "will not start at boot until your kernel is configured properly."
		ewarn
	fi
}
