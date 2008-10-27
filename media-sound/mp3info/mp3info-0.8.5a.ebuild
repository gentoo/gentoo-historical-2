# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3info/mp3info-0.8.5a.ebuild,v 1.8 2008/10/27 15:02:21 jer Exp $

inherit eutils toolchain-funcs

IUSE="gtk"

DESCRIPTION="An MP3 technical info viewer and ID3 1.x tag editor"
SRC_URI="http://ibiblio.org/pub/linux/apps/sound/mp3-utils/${PN}/${P}.tgz"
HOMEPAGE="http://ibiblio.org/mp3info/"

RDEPEND="gtk? ( >=x11-libs/gtk+-2.6.10 )
	sys-libs/ncurses"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ppc ppc64 sparc x86 ~x86-fbsd"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-ldflags.patch"
}

src_compile() {
	emake mp3info CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die
	if use gtk; then
		emake gmp3info CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "gtk mp3info failed"
	fi
}

src_install() {
	dobin mp3info
	use gtk && dobin gmp3info

	dodoc ChangeLog README
	doman mp3info.1
}
