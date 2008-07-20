# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/slock/slock-0.7.ebuild,v 1.7 2008/07/20 14:51:56 cedk Exp $

inherit toolchain-funcs flag-o-matic

DESCRIPTION="simple X screen locker"
HOMEPAGE="http://www.suckless.org/programs/slock.html"
SRC_URI="http://code.suckless.org/dl/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s/.*strip.*//" \
		Makefile || die "sed failed"

	sed -i \
		-e "s/CFLAGS = -Os/CFLAGS +=/" \
		-e "s/LDFLAGS =/LDFLAGS +=/" \
		config.mk || die "sed failed"
}

src_compile() {
	append-ldflags "-Wl,-z,now"
	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"

	dodoc README
}
