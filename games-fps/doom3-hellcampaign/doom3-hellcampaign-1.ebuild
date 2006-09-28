# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doom3-hellcampaign/doom3-hellcampaign-1.ebuild,v 1.4 2006/09/28 21:06:31 nyhm Exp $

inherit eutils games

MOD="hell_campaign"
DESCRIPTION="Map pack for Doom 3"
HOMEPAGE="http://doom3.filefront.com/file/The_Ultimate_Hell_Campaign;52013"
SRC_URI="mirror://filefront/Doom_III/Maps/Map_Packs/sp_hc_final.zip
	mirror://filefront/Doom_III/Maps/Map_Packs/hardcorehellcampaign_patch.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"

RDEPEND="games-fps/doom3"
DEPEND="app-arch/unzip"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/doom3

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Prevent "non-portable" upper-case-filename warnings in Doom 3
	mv "Hardcore Hell Campaign.pk4" hardcore_hell_campaign.pk4
	mv Q2Textures.pk4 q2Textures.pk4
	mv Q3Textures.pk4 q3Textures.pk4

	# Show nice description in "mods" menu within Doom 3
	echo 'Hell Campaign' > description.txt
}

src_install() {
	insinto "${dir}/${MOD}"
	doins -r * || die "doins failed"

	games_make_wrapper ${PN} "doom3 +set fs_game ${MOD}"
	make_desktop_entry ${PN} "Doom III - Hell Campaign" doom3.png

	prepgamesdirs
}
