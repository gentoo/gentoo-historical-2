# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-firmware/alsa-firmware-1.0.2.ebuild,v 1.1 2004/01/27 19:17:48 mholzer Exp $

MY_P=${P/_rc/rc}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Advanced Linux Sound Architecture firmware"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/firmware/${P}.tar.bz2"
RESTRICT="nomirror"

SLOT="0"
KEYWORDS="~x86"
LICENSE="GPL-2"

DEPEND=""

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README
}
