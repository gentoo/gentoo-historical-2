# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iptraf-ng/iptraf-ng-1.0.2.ebuild,v 1.2 2010/06/29 13:51:43 jer Exp $

EAPI=2

inherit flag-o-matic

DESCRIPTION="console-based network monitoring utility, fork off iptraf 3.0.0"
HOMEPAGE="https://fedorahosted.org/iptraf-ng/"
SRC_URI="https://fedorahosted.org/releases/i/p/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unicode"

DEPEND="
	!net-analyzer/iptraf
	unicode? ( sys-libs/ncurses[unicode=] )
"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	keepdir /var/{lib,run,log}/iptraf
}
