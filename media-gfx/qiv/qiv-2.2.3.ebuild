# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/qiv/qiv-2.2.3.ebuild,v 1.2 2010/03/18 13:38:26 ssuominen Exp $

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Quick Image Viewer"
HOMEPAGE="http://spiegl.de/qiv/"
SRC_URI="http://spiegl.de/qiv/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xinerama"

RDEPEND=">=x11-libs/gtk+-2.12:2
	media-libs/imlib2
	!media-gfx/pqiv
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -i \
		-e 's:$(CC) $(CFLAGS):$(CC) $(LDFLAGS) $(CFLAGS):' \
		Makefile || die

	if ! use xinerama; then
		sed -i \
			-e 's:-DGTD_XINERAMA::' \
			Makefile || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	dobin qiv || die
	doman qiv.1
	dodoc Changelog qiv-command.example README README.TODO
}
