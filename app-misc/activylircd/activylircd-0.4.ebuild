# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/activylircd/activylircd-0.4.ebuild,v 1.1 2009/06/13 10:15:27 zzam Exp $

inherit eutils

DESCRIPTION="ACTIVYLIRCD lirc daemon for activy remote control"
HOMEPAGE="http://www.htpc-forum.de/"
SRC_URI="http://www.htpc-forum.de/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_install() {
	dobin activylircd evtest key2xd eventmapper key2lircd key2xd
	dodoc key2x.conf
}
