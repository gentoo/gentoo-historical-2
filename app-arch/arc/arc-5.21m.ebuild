# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/arc/arc-5.21m.ebuild,v 1.4 2005/09/30 18:15:10 corsair Exp $

inherit eutils

DESCRIPTION="Create & extract files from DOS .ARC files"
HOMEPAGE="http://arc.sourceforge.net/"
SRC_URI="mirror://sourceforge/arc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~ppc ppc64 sparc ~x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-compile-cleanups.patch
}

src_compile() {
	emake \
		OPT="${CFLAGS}" \
		LIBS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dobin arc marc || die "dobin failed"
	doman arc.1
	dodoc Arc521.doc Arcinfo Changelog Readme
}
