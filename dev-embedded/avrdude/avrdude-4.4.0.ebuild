# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/avrdude/avrdude-4.4.0.ebuild,v 1.3 2005/01/01 17:51:35 eradicator Exp $


DESCRIPTION="AVR Downloader/UploaDEr"

HOMEPAGE="http://www.nongnu.org/avrdude/"


SRC_URI="http://savannah.nongnu.org/download/avrdude/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="x86"
IUSE=""

DEPEND="app-text/tetex
	sys-devel/flex
	sys-devel/bison
	sys-devel/gcc
	sys-libs/ncurses
	sys-apps/grep
	sys-libs/readline
	virtual/libc
	app-text/texi2html"

RDEPEND="virtual/libc
	sys-libs/ncurses"

src_install() {
	emake DESTDIR=${D} install || die
}
