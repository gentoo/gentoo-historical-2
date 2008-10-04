# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/drascula/drascula-1.0.ebuild,v 1.2 2008/10/04 00:59:34 darkside Exp $

EAPI=1
inherit eutils games

INT_URI="mirror://sourceforge/scummvm/drascula-int-${PV}.zip"
DESCRIPTION="Drascula: The Vampire Strikes Back"
HOMEPAGE="http://www.alcachofasoft.com/"
SRC_URI="mirror://sourceforge/scummvm/drascula-${PV}.zip
	http://scummvm.svn.sourceforge.net/svnroot/scummvm/scummvm/tags/release-0-12-0/dists/engine-data/drascula.dat
	audio? ( mirror://sourceforge/scummvm/drascula-audio-${PV}.zip )
	linguas_es? ( ${INT_URI} )
	linguas_de? ( ${INT_URI} )
	linguas_fr? ( ${INT_URI} )
	linguas_it? ( ${INT_URI} )"

LICENSE="drascula"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio linguas_es linguas_de linguas_fr linguas_it"

RDEPEND=">=games-engines/scummvm-0.12.0"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	if use linguas_es || use linguas_de || use linguas_fr || use linguas_it; then
		unpack drascula-int-${PV}.zip
	fi
	if use audio ; then
		unpack drascula-audio-${PV}.zip
	fi
	unpack drascula-${PV}.zip
}

src_install() {
	local lang

	games_make_wrapper ${PN} "scummvm -f -p \"${GAMES_DATADIR}/${PN}\" drascula" .
	for lang in es de fr it
	do
		if use linguas_${lang} ; then
			games_make_wrapper ${PN}-${lang} "scummvm -q ${lang} -f -p \"${GAMES_DATADIR}/${PN}\" drascula" .
			make_desktop_entry ${PN}-${lang} "Drascula: The Vampire Strikes Back (${lang})" ${PN}
		fi
	done
	insinto "${GAMES_DATADIR}"/${PN}
	doins P*.* "${DISTDIR}"/drascula.dat || die "doins failed"
	if use audio ; then
		doins audio/* || die "doins failed"
	fi
	dodoc readme.txt drascula.doc
	make_desktop_entry ${PN} "Drascula: The Vampire Strikes Back"
	prepgamesdirs
}
