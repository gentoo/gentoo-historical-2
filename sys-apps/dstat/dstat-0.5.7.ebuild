# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dstat/dstat-0.5.7.ebuild,v 1.1 2005/01/26 00:12:07 wschlich Exp $

DESCRIPTION="Dstat is a versatile replacement for vmstat, iostat and ifstat"
HOMEPAGE="http://dag.wieers.com/home-made/dstat/"
SRC_URI="http://dag.wieers.com/home-made/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="virtual/python"
DEPEND=""

src_compile() {
	true
}

src_install() {
	dobin dstat || die "dobin failed"
	dodoc AUTHORS ChangeLog README TODO dstat.conf || die "dodoc failed"
}

pkg_postinst() {
	einfo ""
	einfo "See the included dstat.conf in the doc directory for"
	einfo "an example on how to setup a custom /etc/dstat.conf"
	einfo ""
}
