# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/aylet/aylet-0.3.ebuild,v 1.9 2006/10/30 09:28:09 flameeyes Exp $

inherit eutils

DESCRIPTION="Aylet plays music files in the .ay format"
HOMEPAGE="http://rus.members.beeb.net/aylet.html"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/apps/sound/players/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc amd64 sparc"
IUSE="gtk"

DEPEND="sys-libs/ncurses
	gtk? ( =x11-libs/gtk+-1.2* )"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${P}-gcc41.patch"
}

src_compile() {
	emake CFLAGS="${CFLAGS} -DDRIVER_OSS" aylet || die
	if use gtk; then
		emake CFLAGS="${CFLAGS} -DDRIVER_OSS" xaylet || die
	fi
}

src_install() {
	## binary files
	dobin aylet
	use gtk && dobin xaylet

	## doc and man
	dodoc ChangeLog NEWS README TODO
	doman aylet.1
	use gtk && dosym aylet.1.gz /usr/share/man/man1/xaylet.1.gz
}
