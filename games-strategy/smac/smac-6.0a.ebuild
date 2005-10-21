# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/smac/smac-6.0a.ebuild,v 1.3 2005/10/21 18:17:16 wolf31o2 Exp $

inherit games

IUSE="videos"

DESCRIPTION="Sid Meier's Alpha Centauri"
HOMEPAGE="http://www.lokigames.com/products/smac/"
SRC_URI="mirror://lokigames/${PN}/${P}-x86.run"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="nostrip"

DEPEND="games-util/loki_patch"
RDEPEND="virtual/x11
	sys-libs/lib-compat-loki"

pkg_setup() {
	cdrom_get_cds Alien_Crossfire_Manual.pdf
	games_pkg_setup
}

src_unpack() {
	mkdir -p ${S}/a ${S}/b
	cd ${S}/a
	unpack_makeself ${P}-x86.run
}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_install() {
	dodir ${dir}
	einfo "Copying files... this may take a while..."
	exeinto ${dir}
	doexe ${CDROM_ROOT}/bin/x86/{smac,smacx,smacpack}

	insinto ${dir}
	doins ${CDROM_ROOT}/{{Alien_Crossfire,Alpha_Centauri}_Manual.pdf,QuickStart.txt,README,icon.{bmp,xpm}}

	cd ${Ddir}
	tar xzf ${CDROM_ROOT}/data.tar.gz || die "unpack"
	insinto ${dir}/data
	doins ${CDROM_ROOT}/data/*.{pcx,cvr,flc,gif} || die "copying data"
	doins -r ${CDROM_ROOT}/data/facs || die "copying fac-data"
	doins -r ${CDROM_ROOT}/data/fx || die "copying fx-data"
	doins -r ${CDROM_ROOT}/data/projs || die "copying projects-data"
	doins -r ${CDROM_ROOT}/data/techs || die "copying tech-data"
	doins -r ${CDROM_ROOT}/data/voices || die "copying voices"

	if use videos ; then
		doins -r ${CDROM_ROOT}/data/movies || die "copying movies"
	fi

	cd ${S}/a
	loki_patch --verify patch.dat
	loki_patch patch.dat ${Ddir} >& /dev/null || die "patching"

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find ${Ddir} -exec touch '{}' \;

	insinto /usr/share/pixmaps
	newins ${CDROM_ROOT}/icon.xpm smac.xpm

	games_make_wrapper ${PN} ./${PN} "${dir}" "${dir}"
	games_make_wrapper ${PN}x ./${PN}x "${dir}" "${dir}"
	prepgamesdirs

	einfo "Linking libs provided by 'sys-libs/lib-compat-loki' to '${dir}'."
	dosym /lib/loki_ld-linux.so.2 ${dir}/ld-linux.so.2 && \
	dosym /usr/lib/loki_libc.so.6 ${dir}/libc.so.6 && \
	dosym /usr/lib/loki_libnss_files.so.2 ${dir}/libnss_files.so.2 || die "dosym failed"
}

pkg_postinst() {
	einfo "To play Sid Meyer's Alpha Centauri run:"
	einfo " smac"
	einfo "To play Alien Crossfire run:"
	einfo " smacx"

	games_pkg_postinst
}
