# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/quickshare/quickshare-1.0.ebuild,v 1.1 2011/09/17 23:25:01 ssuominen Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="A simple HTTP server with a GUI which allows for easy sharing of files"
HOMEPAGE="http://houbysoft.com/qs/"
SRC_URI="http://houbysoft.com/download/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-libs/libmicrohttpd
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${P}-src

src_prepare() {
	sed -i \
		-e 's:gcc ${LOPT}:$(CC) $(LDFLAGS):' \
		-e 's:-o $@:-o $@ ${LOPT}:' \
		-e 's:gcc:$(CC):' \
		Makefile || die
}

src_compile() {
	tc-export CC
	emake COPT="${CFLAGS}"
}

src_install() {
	dobin qs
	dodoc README
	insinto /usr/share/quickshare
	doins {on,off}.png
	make_desktop_entry qs QuickShare
}
