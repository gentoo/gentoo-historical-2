# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/reptyr/reptyr-0.3.ebuild,v 1.4 2012/07/23 16:11:34 steev Exp $

EAPI=4

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A utility to attach a running program to a new terminal"
HOMEPAGE="https://github.com/nelhage/reptyr"
SRC_URI="https://github.com/nelhage/${PN}/tarball/${P} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE=""

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_compile() {
	append-cflags -D_GNU_SOURCE
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	dodoc ChangeLog NOTES README
}
