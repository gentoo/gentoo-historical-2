# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/soldieroffortune-demo/soldieroffortune-demo-0.57.ebuild,v 1.1 2006/04/12 21:18:59 wolf31o2 Exp $

inherit eutils multilib games

MY_PN=${PN/soldieroffortune/sof}

DESCRIPTION="First-person shooter based on the mercenary trade"
HOMEPAGE="http://www.lokigames.com/products/sof/"
SRC_URI="mirror://lokigames/loki_demos/${MY_PN}.run"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="nostrip"

DEPEND="games-util/loki_patch"
RDEPEND="media-libs/openal"

S=${WORKDIR}

GAMES_CHECK_LICENSE="yes"
dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	unpack_makeself
}

src_install() {
	local demo="data/demos/sof_demo"
	local exe="sof-bin.x86"

	loki_patch patch.dat data/ || die "loki patch failed"

	insinto "${dir}"
	exeinto "${dir}"
	doins -r "${demo}"/* || die "doins failed"
	doexe "${demo}/${exe}" || die "doexe failed"

	# Replace bad library
	dosym /usr/$(get_libdir)/libSDL.so "${dir}"/libSDL-1.1.so.0 || die

	games_make_wrapper ${PN} "./${exe}" "${dir}" "${dir}"
	newicon "${demo}"/launch/box.png ${PN}.png || die
	make_desktop_entry ${PN} "Soldier of Fortune Demo"

	prepgamesdirs
}
