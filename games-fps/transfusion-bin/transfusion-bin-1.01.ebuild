# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/transfusion-bin/transfusion-bin-1.01.ebuild,v 1.10 2005/05/15 22:41:36 mr_bones_ Exp $

inherit games

MY_PN=${PN/-bin/}
DESCRIPTION="Blood remake"
HOMEPAGE="http://www.transfusion-game.com/"
SRC_URI="mirror://sourceforge/blood/${MY_PN}-1.0-linux.i386.zip
	mirror://sourceforge/blood/${MY_PN}-patch-${PV}-linux.i386.zip
	mirror://gentoo/${MY_PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""
RESTRICT="nostrip"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_PN}

dir=${GAMES_PREFIX_OPT}/${MY_PN}
Ddir=${D}/${dir}

src_install() {
	# install everything that looks anything like docs...
	dodoc ${MY_PN}/doc/*.txt ${MY_PN}/*txt qw/*txt
	dohtml ${MY_PN}/doc/*.html

	#...then mass copy everything to the install dir...
	dodir "${dir}"
	cp -R * "${Ddir}" || die "cp failed"

	# ...and remove the docs since we don't need them installed twice.
	rm -rf \
		"${Ddir}"/${MY_PN}/doc \
		"${Ddir}"/qw/*txt \
		"${Ddir}"/${MY_PN}/*txt

	doicon "${DISTDIR}"/${MY_PN}.png
	games_make_wrapper ${MY_PN} ./${MY_PN}-glx "${dir}"
	make_desktop_entry ${MY_PN} "Transfusion" ${MY_PN}.png

	prepgamesdirs
}
