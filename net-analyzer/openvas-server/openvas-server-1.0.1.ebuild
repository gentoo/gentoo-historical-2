# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/openvas-server/openvas-server-1.0.1.ebuild,v 1.2 2008/07/11 14:41:42 carlo Exp $

DESCRIPTION="A remote security scanner for Linux (openvas-server)"
HOMEPAGE="http://www.openvas.org/"
SRC_URI="http://wald.intevation.org/frs/download.php/469/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="tcpd gtk debug prelude"

DEPEND=">=net-analyzer/openvas-libraries-1.0.2
	>=net-analyzer/openvas-libnasl-1.0.1
	tcpd? ( sys-apps/tcp-wrappers )
	gtk? ( =x11-libs/gtk+-2* )
	prelude? ( dev-libs/libprelude )"

src_compile() {
	econf \
		$(use_enable tcpd tcpwrappers) \
		$(use_enable debug) \
		$(use_enable gtk) \
		|| die "configure failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"

	dodoc TODO CHANGES || die
	dodoc doc/*.txt doc/ntp/* || die

	doinitd "${FILESDIR}"/openvasd || die "doinitd failed"
	keepdir /var/lib/openvas/logs
	keepdir /var/lib/openvas/users
}
