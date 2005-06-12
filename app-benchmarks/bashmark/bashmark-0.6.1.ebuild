# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/bashmark/bashmark-0.6.1.ebuild,v 1.1 2005/06/12 18:29:01 genstef Exp $

DESCRIPTION="Geno's cross platform benchmarking suite"
HOMEPAGE="http://bashmark.coders-net.de"

SRC_URI="http://bashmark.coders-net.de/download/src/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_install() {
	dobin bashmark
	dodoc Changelog
}
