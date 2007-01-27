# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-kids/childsplay/childsplay-0.85.1.ebuild,v 1.1 2007/01/27 09:08:13 mr_bones_ Exp $

inherit games python

DESCRIPTION="A suite of educational games for young children"
HOMEPAGE="http://childsplay.sourceforge.net/"
PLUGINS_VERSION="0.85.2"
PLUGINS_LFC_VERSION="0.85.2"
SRC_URI="mirror://sourceforge/childsplay/${P}.tgz
	mirror://sourceforge/childsplay/${PN}_plugins-${PLUGINS_VERSION}.tgz
	mirror://sourceforge/childsplay/${PN}_plugins_lfc-${PLUGINS_LFC_VERSION}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.1
	>=dev-python/pygame-1.6
	>=media-libs/sdl-image-1.2
	>=media-libs/sdl-ttf-2.0
	>=media-libs/sdl-mixer-1.2
	media-libs/libogg"

src_unpack() {
	local DIR

	# Copy the plugins into the main package.
	unpack ${A}
	for DIR in ${PN}_plugins-${PLUGINS_VERSION} ${PN}_plugins_lfc-${PLUGINS_LFC_VERSION}; do
		cp -r ${DIR}/Data/*.icon.png ${P}/Data/icons || die
		cp -r ${DIR}/lib/* ${P}/lib || die
		cp -r ${DIR}/assetml/* ${P}/assetml || die
	done
	cp -r ${PN}_plugins-${PLUGINS_VERSION}/Data/AlphabetSounds ${P}/Data || die
	cp ${PN}_plugins-${PLUGINS_VERSION}/add-score.py ${P} || die
	cd "${S}"
	gunzip man/childsplay.6.gz
}

src_install() {
	local fn

	# The following variables are based on Childsplay's INSTALL.sh
	_LOCALEDIR=/usr/share/locale
	_ASSETMLDIR=/usr/share/assetml
	_SCOREDIR=${GAMES_STATEDIR}
	_SCOREFILE=${_SCOREDIR}/childsplay.score
	_CPDIR=${GAMES_LIBDIR}/childsplay
	_SHAREDIR=${GAMES_DATADIR}/childsplay
	_LIBDIR=${_CPDIR}/lib
	_MODULESDIR=${_LIBDIR}
	_SHARELIBDATADIR=${_SHAREDIR}/lib
	_SHAREDATADIR=${_SHAREDIR}/Data
	_RCDIR=${_SHARELIBDATADIR}/ConfigData
	_HOME_DIR_NAME=.childsplay
	_CHILDSPLAYRC=childsplayrc

	dodir \
		"${_CPDIR}" \
		"${_LIBDIR}" \
		"${_SHAREDIR}" \
		"${_SHARELIBDATADIR}" \
		"${_SCOREDIR}" \
		"${_LOCALEDIR}" \
		"${_ASSETMLDIR}"

	# create BASEPATH.py
	cat >BASEPATH.py <<EOF
## Automated file--please do not edit
LOCALEDIR="${_LOCALEDIR}"
ASSETMLDIR="${_ASSETMLDIR}"
SCOREDIR="${_SCOREDIR}"
SCOREFILE="${_SCOREFILE}"
CPDIR="${_CPDIR}"
SHAREDIR="${_SHAREDIR}"
LIBDIR="${_LIBDIR}"
MODULESDIR="${_MODULESDIR}"
SHARELIBDATADIR="${_SHARELIBDATADIR}"
SHAREDATADIR="${_SHAREDATADIR}"
RCDIR="${_RCDIR}"
HOME_DIR_NAME="${_HOME_DIR_NAME}"
CHILDSPLAYRC="${_CHILDSPLAYRC}"
EOF

	# copy software and data
	cp -r *.py "${D}/${_CPDIR}" || die "cp failed"
	cp -r Data "${D}/${_SHAREDIR}" || die "cp failed"
	rm "${D}/${_SHAREDIR}/Data/childsplay.score"  # this copy won't be used

	for fn in $(ls lib); do
		if [ -d lib/${fn} ]; then
			cp -r lib/${fn} "${D}/${_SHARELIBDATADIR}" || die
		else
			cp lib/${fn} "${D}/${_LIBDIR}" || die
		fi
	done

	cp -r locale/* "${D}/${_LOCALEDIR}" || die
	cp -r assetml/* "${D}/${_ASSETMLDIR}" || die

	# initialize the score file
	cp Data/childsplay.score "${D}/${_SCOREFILE}" || die
	SCORE_GAMES="Packid,Numbers,Soundmemory,Fallingletters,Findsound,Findsound2,Billiard"
	python add-score.py "${D}/${_SCOREDIR}" $SCORE_GAMES

	# translate for the letters game
	python letters-trans.py "${D}/${_ASSETMLDIR}"

	doman man/childsplay.6
	dodoc doc/README* doc/Changelog doc/copyright

	# Make a launcher.
	dogamesbin "${FILESDIR}"/childsplay
	dosed "s:GENTOO_DIR:${_CPDIR}:" "${GAMES_BINDIR}"/childsplay

	prepgamesdirs
	fperms g+w "${_SCOREFILE}"
}

pkg_postinst() {
	python_mod_optimize "${_CPDIR}"
	games_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup "${_CPDIR}"
}
