# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libip_vs_user_sync/libip_vs_user_sync-1.0.0.ebuild,v 1.1 2004/08/31 15:34:14 tantive Exp $

inherit eutils

DESCRIPTION="Library to access LVS netlink socket in the Linux Kernel"

HOMEPAGE="http://www.ultramonkey.org/download/conn_sync/"
LICENSE="GPL-2"
DEPEND="virtual/glibc
	>=dev-libs/vanessa-logger-0.0.6"
SRC_URI="http://www.ultramonkey.org/download/conn_sync/${P}.tar.gz"
SLOT="0"
KEYWORDS="-*"
IUSE=""
S="${WORKDIR}/${P}"

src_compile() {
	einfo "libip_vs_user_sync needs a kernel patched with linux-2.4.26-user_sync.3.patch"
	einfo "you can download the patch at the following url http://www.ultramonkey.org/download/conn_sync/"
	econf
	cd "${S}"
	make || die
}

src_install() {
	einstall || die
	dodoc README NEWS AUTHORS TODO INSTALL ChangeLog
	einfo ""
}
