# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/kochi-substitute/kochi-substitute-20030626.ebuild,v 1.3 2004/05/14 01:53:52 geoman Exp $

IUSE="X"

FONT_PATH="/usr/X11R6/lib/X11/fonts/truetype"
DESCRIPTION="Kochi Japanese TrueType fonts with Wadalab Fonts"
HOMEPAGE="http://efont.sourceforge.jp/"
SRC_URI="http://downloads.sourceforge.jp/efont/4845/${P}.tar.bz2"

# naga10 has free-noncomm license
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="x86 alpha sparc ppc"

DEPEND="virtual/glibc
	X? ( virtual/x11 )"

S=${WORKDIR}/${PN}-${PV:0:8}

src_install () {

	insinto ${FONT_PATH}
	doins kochi-gothic-subst.ttf
	doins kochi-mincho-subst.ttf
	dosym kochi-gothic-subst.ttf ${FONT_PATH}/kochi-gothic.ttf
	dosym kochi-mincho-subst.ttf ${FONT_PATH}/kochi-mincho.ttf

	dodoc README.ja COPYING
}

rebuild_fontfiles() {

	einfo "Refreshing fonts.scale and fonts.dir..."

	cd ${FONT_PATH}

	# recreate fonts.scale
	ttmkfdir > fonts.scale \
		|| die "Unable to create fonts.scale! Please emerge ttmkfdir and try again."

	# recreate fonts.dir
	mkfontdir -e /usr/X11R6/lib/X11/fonts/encodings

	if [ -x /usr/bin/fc-cache ] ; then
		einfo "Updating font cache..."
		/usr/bin/fc-cache -f ${FONT_PATH}
	fi
}

pkg_postinst() {

	use X > /dev/null && rebuild_fontfiles

	echo ""
	einfo "This is a Kochi \"alternative\" font, but not kochi font itself."
	einfo "Unfortunately, there is a possibility of copyright infringement,"
	einfo "so the author of kochi font suspended distributing kochi font."
	einfo "Please see http://khdd.net/kanou/fonts/stolenbitmap.en.html and"
	einfo "${HOMEPAGE} for details."
}

pkg_postrm() {

	use X > /dev/null && rebuild_fontfiles
}
