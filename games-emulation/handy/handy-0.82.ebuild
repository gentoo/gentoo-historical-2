# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/handy/handy-0.82.ebuild,v 1.6 2006/09/19 19:02:26 wolf31o2 Exp $

inherit games

MY_RLS="R1"
DESCRIPTION="A Atari Lynx emulator for Linux"
HOMEPAGE="http://sdlemu.ngemu.com/handysdl.php"
SRC_URI="http://sdlemu.ngemu.com/releases/Handy-SDL-${PV}${MY_RLS}.i386.linux-glibc22.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* x86"
RESTRICT="strip"
IUSE=""

RDEPEND="media-libs/libsdl
	sys-libs/zlib
	virtual/libc
	sys-libs/lib-compat"

S=${WORKDIR}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	exeinto "${dir}"
	newexe sdlhandy handy || die "doexe failed"
	dohtml -r docs/*
	games_make_wrapper sdlhandy ./sdlhandy "${dir}" "${dir}"
	games_make_wrapper handy ./handy "${dir}" "${dir}"
	prepgamesdirs
}
