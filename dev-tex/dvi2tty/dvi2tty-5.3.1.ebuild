# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/dvi2tty/dvi2tty-5.3.1.ebuild,v 1.10 2008/09/23 21:00:43 armin76 Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Preview dvi-files on text-only devices"
HOMEPAGE="http://www.ctan.org/tex-archive/dviware/"
SRC_URI="ftp://ftp.mesa.nl/pub/dvi2tty/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${PN}-gcc.patch"
	epatch "${FILESDIR}/${PN}-cflags.patch"
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	dobin dvi2tty disdvi
	doman dvi2tty.1 disdvi.1
	dodoc README
}
