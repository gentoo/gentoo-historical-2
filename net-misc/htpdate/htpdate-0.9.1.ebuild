# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/htpdate/htpdate-0.9.1.ebuild,v 1.1 2006/03/25 11:07:21 dertobi123 Exp $

inherit toolchain-funcs eutils

DESCRIPTION="Synchronize local workstation with time offered by remote webservers"
HOMEPAGE="http://www.clevervest.com/htp/"
SRC_URI="http://www.clevervest.com/htp/archive/c/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die
}

src_install () {
	dosbin htpdate || die
	doman htpdate.8.gz || die
	dodoc README Changelog || die
}
