# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/moreutils/moreutils-0.30-r1.ebuild,v 1.1 2008/05/31 17:16:47 coldwind Exp $

EAPI=1

inherit eutils

DESCRIPTION="a growing collection of the unix tools that nobody thought to write
thirty years ago"
HOMEPAGE="http://kitenet.net/~joey/code/moreutils/"
SRC_URI="http://ftp.de.debian.org/debian/pool/main/m/moreutils/moreutils_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	>=app-text/docbook2X-0.8.8-r2
	app-text/docbook-xml-dtd:4.4"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-dtd-path.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS}" DOCBOOK2XMAN="docbook2man.pl" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_BIN=install install || die "install failed"
}
