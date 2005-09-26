# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/0verkill/0verkill-0.16-r2.ebuild,v 1.7 2005/09/26 19:23:07 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="A bloody 2D action deathmatch-like game in ASCII-ART"
HOMEPAGE="http://artax.karlin.mff.cuni.cz/~brain/0verkill/"
SRC_URI="http://artax.karlin.mff.cuni.cz/~brain/0verkill/release/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64"
IUSE="X"

RDEPEND="X? ( virtual/x11 )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-docs.patch
	epatch ${FILESDIR}/${PV}-home-overflow.patch
	epatch ${FILESDIR}/${PV}-gentoo-paths.patch
	sed -i \
		-e "s:data/:${GAMES_DATADIR}/${PN}/data/:" cfg.h \
		|| die "sed failed"
	sed -i \
		-e "s:@CFLAGS@ -O3 :@CFLAGS@ :" Makefile.in \
		|| die "sed failed"
}

src_compile() {
	egamesconf $(use_with X x) || die
	emake || die "emake failed"
}

src_install() {
	dogamesbin 0verkill
	newgamesbin avi 0verkill-avi
	newgamesbin editor 0verkill-editor
	if use X ; then
		dogamesbin x0verkill
		newgamesbin xavi x0verkill-avi
		newgamesbin xeditor x0verkill-editor

	fi
	newgamesbin bot 0verkill-bot
	newgamesbin server 0verkill-server
	newgamesbin test_server 0verkill-test_server

	insinto ${GAMES_DATADIR}/${PN}/data
	doins data/*
	insinto ${GAMES_DATADIR}/${PN}/grx
	doins grx/*

	dohtml doc/*.htm
	rm doc/*.html doc/README.OS2 doc/Readme\ Win32.txt doc/COPYING
	dodoc doc/*

	prepgamesdirs
}
