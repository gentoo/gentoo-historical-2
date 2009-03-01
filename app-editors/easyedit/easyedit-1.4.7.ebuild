# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/easyedit/easyedit-1.4.7.ebuild,v 1.1 2009/03/01 16:44:20 patrick Exp $

inherit toolchain-funcs

IUSE=""

DESCRIPTION="An easy to use text editor. Intended to be usable with little or no instruction."
HOMEPAGE="http://mahon.cwx.net/"
SRC_URI="http://mahon.cwx.net/sources/ee-${PV}.src.tgz"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"

DEPEND=">=sys-libs/ncurses-5.0"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e "s/\tcc /\t\\\\\$(CC) /" -e "/other_cflag/s/ *-s//" create.make
	emake localmake
	sed -i -e 's/-DNCURSES//' make.local
}

src_compile() {
	emake -f make.local CC="$(tc-getCC)" curses || die
}

src_install() {
	dobin ee
	doman ee.1
	dodoc README.ee Changes ee.i18n.guide ee.msg
}
