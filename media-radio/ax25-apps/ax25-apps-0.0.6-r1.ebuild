# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/ax25-apps/ax25-apps-0.0.6-r1.ebuild,v 1.4 2004/07/01 10:47:05 eradicator Exp $

DESCRIPTION="Basic AX.25 (Amateur Radio) user tools, additional daemons"
HOMEPAGE="http://ax25.sourceforge.net/"
SRC_URI="mirror://sourceforge/ax25/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/libc
	>=dev-libs/libax25-0.0.7"

src_install() {
	make DESTDIR=${D} install installconf || die

	exeinto /etc/init.d ; newexe ${FILESDIR}/ax25ipd.rc ax25ipd
	newexe ${FILESDIR}/ax25mond.rc ax25mond
	newexe ${FILESDIR}/ax25rtd.rc ax25rtd

	# Make the documentation installation more Gentoo-like
	rm -rf ${D}/usr/share/doc/ax25-apps
	dodoc AUTHORS COPYING NEWS README ax25ipd/COPYING.ax25ipd \
	ax25ipd/README.ax25ipd ax25rtd/README.ax25rtd \
	ax25ipd/HISTORY.ax25ipd ax25rtd/TODO.ax25rtd

	# FIXME: Configuration protect logic for the ax25rtd cache
	#   or move these files
	# Moving might require changes to ax25rtd/ax25rtctl
	insinto /var/lib/ax25/ax25rtd
	newins ${FILESDIR}/ax25rtd.blank ax25_route
	newins ${FILESDIR}/ax25rtd.blank ip_route
}
