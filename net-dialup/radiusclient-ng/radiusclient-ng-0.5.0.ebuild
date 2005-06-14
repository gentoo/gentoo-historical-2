# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/radiusclient-ng/radiusclient-ng-0.5.0.ebuild,v 1.2 2005/06/14 03:23:43 weeve Exp $

inherit eutils

DESCRIPTION="RadiusClient NextGeneration - a library for writing RADIUS clients accompanied with several client utilities."
HOMEPAGE="http://developer.berlios.de/projects/${PN}/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~sparc ~x86"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/pkgsysconfdir-install.patch
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README BUGS CHANGES COPYRIGHT
	dohtml doc/instop.html
}
