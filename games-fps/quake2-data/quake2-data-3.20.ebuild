# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake2-data/quake2-data-3.20.ebuild,v 1.13 2005/09/26 18:10:14 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="iD Software's Quake 2 ... the data files"
HOMEPAGE="http://www.idsoftware.com/"
SRC_URI="ftp://ftp.idsoftware.com/idstuff/quake2/q2-${PV}-x86-full-ctf.exe"

LICENSE="Q2EULA"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="videos"

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

pkg_setup() {
	cdrom_get_cds Install
	if [[ -e ${CDROM_ROOT}/Install/Data ]] ; then
		export CDROM_ROOT=${CDROM_ROOT}/Install/Data
		einfo "Source is the CD"
	elif [[ -e ${CDROM_ROOT}/baseq2 ]] ; then
		export CDROM_ROOT=${CDROM_ROOT}
		einfo "Source is an installed copy"
	else
		die "Could not determine what ${CDROM_ROOT} points at"
	fi

	games_pkg_setup
}

src_unpack() {
	echo ">>> Unpacking ${A} to ${PWD}"
	unzip -Lqo "${DISTDIR}/${A}"
}

src_install() {
	dodoc DOCS/* 3.20_Changes.txt
	newdoc ctf/readme.txt ctf-readme.txt
	dohtml -r "${CDROM_ROOT}"/DOCS/quake2_manual/*

	dodir ${GAMES_DATADIR}/${PN}/baseq2

	if use videos ; then
		insinto ${GAMES_DATADIR}/${PN}/baseq2/video
		doins "${CDROM_ROOT}"/baseq2/video/*
	fi

	insinto ${GAMES_DATADIR}/${PN}/baseq2
	doins "${CDROM_ROOT}"/baseq2/pak0.pak || die "couldnt grab pak0.pak"
	doins baseq2/*.pak || die "couldnt grab release paks"
	doins baseq2/maps.lst || die "couldnt grab maps.lst"
	cp -R baseq2/players "${D}/${GAMES_DATADIR}"/${PN}/baseq2/ || die "couldnt grab player models"

	insinto "${GAMES_DATADIR}"/${PN}/ctf
	doins ctf/*.{cfg,ico,pak} || die "couldnt grab ctf"

	prepgamesdirs
}
