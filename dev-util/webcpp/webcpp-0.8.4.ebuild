# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/webcpp/webcpp-0.8.4.ebuild,v 1.3 2005/09/30 16:03:18 metalgod Exp $

inherit toolchain-funcs

S=${WORKDIR}/${P}-src
DESCRIPTION="converts source code into HTML file using a customizable syntax highlighting engine and colour schemes"
HOMEPAGE="http://webcpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/webcpp/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="sys-devel/gcc
	virtual/libc"

pkg_setup() {
	[ `gcc-major-version` -eq 2 ] \
		&& die "WebCPP only works with gcc-3.x" \
		|| return 0
}

src_compile() {
	econf --with-gnu-ld || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS CREDITS ChangeLog README TODO
}
