# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/darwinia-demo/darwinia-demo-1.2.1.ebuild,v 1.6 2005/11/22 00:26:49 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="Darwinia, the hyped indie game of the year. By the Uplink creators."
HOMEPAGE="http://www.darwinia.co.uk/downloads/demo_linux.html"
SRC_URI="http://www.introversion.co.uk/darwinia/downloads/${P}.sh"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="nostrip"

RDEPEND="sys-libs/glibc
	virtual/opengl
	amd64? ( app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-compat )"

S=${WORKDIR}

GAMES_CHECK_LICENSE="yes"
dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	unpack_makeself
}

src_install() {
	exeinto "${dir}/lib"
	doexe lib/lib{gcc_s.so.1,SDL-1.2.so.0,vorbis{.so.0,file.so.3},ogg.so.0} \
		|| die "Copying libraries"
	doexe lib/{darwinia.bin.x86,open-www.sh} || die "copying executables"
	insinto "${dir}/lib"
	doins lib/{sounds,main,language}.dat || die "copying data files"
	insinto "${dir}"
	dodoc README || die "copying docs"

	exeinto "${dir}"
	doexe bin/Linux/x86/darwinia || die "couldn't do exe"

	games_make_wrapper darwinia-demo ./darwinia "${dir}" "${dir}"
	prepgamesdirs
}
