# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tmpreaper/tmpreaper-1.5.1.ebuild,v 1.3 2004/07/01 21:41:38 eradicator Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A utility for removing files based on when they were last accessed"
SRC_URI="http://ftp.debian.org/debian/pool/main/t/tmpreaper/${PN}_${PV}.tar.gz"
HOMEPAGE="http://packages.debian.org/stable/admin/tmpreaper.html"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc "
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/libc"

src_install() {
	einstall || die
	dodoc debian/{ChangeLog,conffiles,copyright,cron.daily,dirs}
}
