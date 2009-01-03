# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/shmux/shmux-1.0.2.ebuild,v 1.1 2009/01/03 13:54:10 swegener Exp $

DESCRIPTION="Program for executing the same command on many hosts in parallel"
HOMEPAGE="http://web.taranis.org/shmux/"
SRC_URI="http://web.taranis.org/${PN}/dist/${P}.tgz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="pcre"
RESTRICT="test"
RDEPEND="pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}
	sys-apps/gawk"

src_compile() {
	econf $(use_with pcre) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin src/shmux || die "dobin failed"
	doman shmux.1 || die "doman failed"
	dodoc CHANGES || die "dodoc failed"
}
