# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-musepack/xmms-musepack-1.1_alpha7.ebuild,v 1.1 2004/09/05 22:23:11 eradicator Exp $

IUSE=""

MY_P="${P/_alpha/-alpha}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="XMMS plugin to play audio files encoded with Andree Buschmann's encoder Musepack (mpc, mp+, mpp)"
HOMEPAGE="http://www.musepack.net"
SRC_URI="http://www.saunalahti.fi/cse/seed/downloads/linux/plugins/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

DEPEND="media-sound/xmms
	media-libs/libmusepack"
	
src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i 's:-O2 -march=i686 -pipe:${CFLAGS}:g' Makefile
}	

src_compile() {
        emake || die "make failed"
}

src_install() {
	exeinto `xmms-config --input-plugin-dir`
	doexe libmpc.so
	dodoc README
}
