# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/pcgen/pcgen-5.4.ebuild,v 1.2 2004/02/29 21:10:42 vapier Exp $

inherit games

MY_PV="${PV//.}"
DESCRIPTION="D&D character generator"
HOMEPAGE="http://pcgen.sourceforge.net"
SRC_URI="mirror://sourceforge/pcgen/pcgen${MY_PV}_part1of3.zip
	mirror://sourceforge/pcgen/pcgen${MY_PV}_part2of3.zip
	mirror://sourceforge/pcgen/pcgen${MY_PV}_part3of3.zip
	mirror://sourceforge/pcgen/skin.zip
	mirror://sourceforge/pcgen/pdf_new.zip"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"

RDEPEND="|| ( >=virtual/jdk-1.3.1 >=virtual/jre-1.3.1 )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	PDF_FILES="pdf_new.zip"
	unpack pcgen${MY_PV}_part{1,2,3}of3.zip skin.zip
	cd ${S}/lib
	unpack pdf_new.zip

	cd ${S}
	# bat file? bat file?  We don't need no stinking bat file.
	rm pcgen.bat
	sed -i "/dirname/ c\cd \"${GAMES_DATADIR}\/${PN}\"" pcgen.sh \
		|| die "sed pcgen.sh failed"
}

src_install() {
	local dir=${GAMES_DATADIR}/${PN}

	newgamesbin pcgen.sh pcgen
	dodir ${dir}
	cp -R ${WORKDIR}/* ${D}/${dir}
	echo "pcgen.filepaths=user" > ${D}/${dir}/filepaths.ini
	rm ${D}/${dir}/pcgen.sh

	prepgamesdirs
	fperms g+w ${dir}/filepaths.ini
}
