# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doom3-chextrek/doom3-chextrek-0.5_beta.ebuild,v 1.6 2007/03/12 14:29:13 genone Exp $

inherit eutils versionator games

# Changes "0.5_beta" to "beta_0.5"
MY_PV=$(get_version_component_range 3-3)$(get_version_component_range 1-2)
MY_PV=${MY_PV/beta/beta_}
MY_P="chextrek${MY_PV}"

MOD="chextrek"
DESCRIPTION="Green slimeballs mod for kids"
HOMEPAGE="http://www.chextrek.xv15mods.com/"
SRC_URI="mirror://filefront/Doom_III/Supported_Mods/Beta_Releases/Chex_Trek_Beyond_the_Quest/${MY_P}.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="games-fps/doom3"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}
dir=${GAMES_PREFIX_OPT}/doom3

src_install() {
	insinto "${dir}"/${MOD}
	doins -r * || die "doins failed"

	games_make_wrapper ${PN} "doom3 +set fs_game ${MOD}"
	make_desktop_entry ${PN} "Doom III - Chex Trek" doom3.png

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Press 'E' to open doors in the game."
	elog "Press 'M' to toggle the map."
}
