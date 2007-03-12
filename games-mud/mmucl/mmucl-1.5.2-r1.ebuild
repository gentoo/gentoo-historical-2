# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/mmucl/mmucl-1.5.2-r1.ebuild,v 1.4 2007/03/12 17:03:58 genone Exp $

inherit games

DESCRIPTION="Marks MUd CLient - A mud client written completely in tcl/tk"
HOMEPAGE="http://mmucl.sourceforge.net/"
SRC_URI="mirror://sourceforge/mmucl/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="readline mccp gtk"

DEPEND=">=dev-lang/tk-8.4
	readline? ( dev-tcltk/tclreadline )
	mccp? ( dev-tcltk/tcl-mccp )
	gtk? ( dev-tcltk/tcl-gtk )"

src_unpack() {
	unpack ${A}

	sed -i \
		-e "/^BASE_DIR/ s:=.*:=/usr:" \
		-e "/^BIN_DIR/ s:=.*:=${GAMES_BINDIR}:" \
		-e "/^LIB_DIR/ s:=.*:=${GAMES_LIBDIR}/${PN}:" \
		-e "" "${S}/Makefile" \
		|| die "sed Makefile failed"
}

src_install () {
	local LIBDIR="${GAMES_LIBDIR}/${PN}"

	dogamesbin mmucl2                 || die "dogamesbin failed"
	insinto ${LIBDIR}/lib
	doins lib/*.tcl                   || die "doins failed (lib)"
	insinto ${LIBDIR}/images
	doins images/*.gif                || die "doins failed (images)"
	insinto ${LIBDIR}/interface
	doins interface/*.tcl             || die "doins failed (interface)"
	insinto ${LIBDIR}/script
	doins script/*.{tcl,rc}           || die "doins failed (script)"
	insinto ${LIBDIR}/script/contrib
	doins script/contrib/*            || die "doins failed (contrib)"
	insinto ${LIBDIR}/test
	doins test/*.test                 || die "doins failed (test)"
	doinfo mmucl.info                 || die "doinfo failed"
	dodoc CHANGES TODO README || die "dodoc failed"
	dohtml mmucl.html                 || die "dohtml failed"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "The executable for this is mmucl2."
}
