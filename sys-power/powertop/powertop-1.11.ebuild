# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/powertop/powertop-1.11.ebuild,v 1.5 2010/02/03 19:39:16 hwoarang Exp $

inherit toolchain-funcs eutils

DESCRIPTION="tool that helps you find what software is using the most power"
HOMEPAGE="http://www.lesswatts.org/projects/powertop/"
SRC_URI="http://www.lesswatts.org/projects/powertop/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~sparc x86"
IUSE="unicode"

DEPEND="sys-libs/ncurses
	sys-devel/gettext"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i '/${CFLAGS}/s:$: ${LDFLAGS}:' Makefile
	use unicode || sed -i 's:-lncursesw:-lncurses:' Makefile
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc Changelog README
	gunzip "${D}"/usr/share/man/man1/powertop.1.gz
}

pkg_postinst() {
	echo
	einfo "For PowerTOP to work best, use a Linux kernel with the"
	einfo "tickless idle (NO_HZ) feature enabled (version 2.6.21 or later)"
	echo
}
