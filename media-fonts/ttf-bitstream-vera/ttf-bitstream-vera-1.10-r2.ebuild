# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/ttf-bitstream-vera/ttf-bitstream-vera-1.10-r2.ebuild,v 1.11 2004/06/24 22:31:35 agriffis Exp $

inherit gnome.org

DESCRIPTION="Bitstream Vera font family"
HOMEPAGE="http://www.gnome.org/fonts/"
LICENSE="BitstreamVera"

SLOT="0"
KEYWORDS="x86 ppc sparc alpha ~mips amd64 hppa ia64"
IUSE=""

DEPEND="X? ( virtual/x11 )"

src_install() {
	insinto /usr/share/fonts/${PN}
	doins *.ttf

	if use X ;
	then
		mkfontscale
		mkfontdir
		doins fonts*
	fi

	dodoc COPYRIGHT.TXT README.TXT RELEASENOTES.TXT
}

pkg_postinst() {
	if [ "${ROOT}" = "/" ] &&  [ -x /usr/bin/fc-cache ]
	then
		echo
		einfo "Creating font cache..."
		HOME="/root" /usr/bin/fc-cache -f
	fi

	einfo "For optimal performance of this font we suggest updating to at least fontconfig-2.1.94 ."
}
