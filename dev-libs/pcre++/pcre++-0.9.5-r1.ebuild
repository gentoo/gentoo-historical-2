# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pcre++/pcre++-0.9.5-r1.ebuild,v 1.2 2007/02/08 18:09:14 ferdy Exp $

IUSE=""

inherit eutils autotools

DESCRIPTION="A C++ support library for libpcre"
HOMEPAGE="http://www.daemon.de/PCRE"
SRC_URI="ftp://ftp.daemon.de/scip/Apps/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-patches.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

DEPEND="dev-libs/libpcre"

src_unpack() {
	unpack ${A}
	cd "${S}"

	for p in "${WORKDIR}"/${P}-patches/*.patch ; do
		epatch "${p}"
	done

	./autogen.sh || die "autogen.sh failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make failed"
	dodoc AUTHORS ChangeLog NEWS README TODO

	cd ${S}/doc/html
	dohtml -r .

	cd ${S}/doc/man/man3
	doman Pcre.3
}
