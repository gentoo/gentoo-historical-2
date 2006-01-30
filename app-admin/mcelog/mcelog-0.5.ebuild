# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/mcelog/mcelog-0.5.ebuild,v 1.1 2006/01/30 13:43:00 blubb Exp $

DESCRIPTION="A tool to log and decode Machine Check Exceptions"
HOMEPAGE="ftp://ftp.x86-64.org/pub/linux/tools/mcelog/"
SRC_URI="ftp://ftp.x86-64.org/pub/linux/tools/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="virtual/cron"

src_install() {
	dosbin mcelog
	doman mcelog.8

	exeinto /etc/cron.daily
	newexe mcelog.cron mcelog
	
	insinto /etc/logrotate.d/
	newins mcelog.logrotate mcelog
	
	dodoc CHANGES README
}
