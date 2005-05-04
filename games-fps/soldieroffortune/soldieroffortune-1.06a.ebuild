# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/soldieroffortune/soldieroffortune-1.06a.ebuild,v 1.10 2005/05/04 13:07:07 wolf31o2 Exp $

inherit games

DESCRIPTION="First-person shooter based on the mercenary trade"
HOMEPAGE="http://www.lokigames.com/products/sof/"
SRC_URI="ftp://ftp.planetmirror.com/pub/lokigames/updates/sof/sof-${PV}-cdrom-x86.run
	ftp://snuffleupagus.animearchive.org/loki/updates/sof/sof-${PV}-cdrom-x86.run"

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="x86"
RESTRICT="nostrip"
IUSE=""

DEPEND="virtual/libc
	games-util/loki_patch"
RDEPEND="virtual/opengl"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

pkg_setup() {
	ewarn "The installed game takes about 725MB of space!"
	cdrom_get_cds sof.xpm
	games_pkg_setup
}

src_unpack() {
	unpack_makeself
}

src_install() {
	dodir ${dir}
	einfo "Copying files... this may take a while..."
	exeinto ${dir}
	doexe ${CDROM_ROOT}/bin/x86/glibc-2.1/sof
	insinto ${dir}
	doins ${CDROM_ROOT}/{README,kver.pub,sof.xpm}

	tar xzf ${CDROM_ROOT}/paks.tar.gz -C ${Ddir} \
		|| die "uncompressing data"
	tar xzf ${CDROM_ROOT}/binaries.tar.gz -C ${Ddir} \
		|| die "uncompressing binaries"

	cd ${S}
	loki_patch --verify patch.dat
	loki_patch patch.dat ${Ddir} >& /dev/null || die "patching"

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find ${Ddir} -exec touch '{}' \;

	games_make_wrapper sof ./sof ${dir}
	doicon ${CDROM_ROOT}/sof.xpm

	prepgamesdirs
	make_desktop_entry sof "Soldier of Fortune" sof.xpm
}

pkg_postinst() {
	games_pkg_postinst
	einfo "To play the game run:"
	einfo " sof"
}
