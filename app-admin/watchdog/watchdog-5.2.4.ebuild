# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/watchdog/watchdog-5.2.4.ebuild,v 1.4 2004/08/30 23:43:30 dholm Exp $

inherit eutils

DESCRIPTION="A software watchdog"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/system/daemons/watchdog/"
SRC_URI="mirror://debian/pool/main/w/watchdog/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~arm ~amd64 ~ppc"
IUSE=""

DEPEND="virtual/libc"

S=${WORKDIR}/${P}.orig

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-sundries.patch
	[ "${PORTAGE_LIBC}" == "uclibc" ] && epatch ${FILESDIR}/${PV}-uclibc.patch
}

src_compile() {
	econf \
		--sysconfdir=/etc/watchdog \
		--with-configfile=/etc/watchdog/watchdog.conf \
		|| die "econf failed"
	emake || die
}

src_install() {
	dodir /etc/watchdog
	make DESTDIR="${D}" install || die

	exeinto /etc/init.d
	doexe ${FILESDIR}/watchdog
	insinto /etc/conf.d
	newins ${FILESDIR}/watchdog.conf.d watchdog
}

pkg_postinst() {
	einfo "To enable the start-up script run \"rc-update add watchdog boot\"."
	if [ ! -e ${ROOT}/dev/watchdog ]
	then
		ewarn "No /dev/watchdog found! Make sure your kernel has watchdog support"
		ewarn "compiled in or the kernel module is loaded. The watchdog service"
		ewarn "will not start at boot until your kernel is configured properly."
	fi
}
