# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-firmware/alsa-firmware-1.0.0_rc2.ebuild,v 1.1 2003/12/07 19:39:11 mholzer Exp $

MY_P=${P/_rc/rc}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Advanced Linux Sound Architecture firmware"
HOMEPAGE="http://www.alsa-project.org/"

SRC_URI="ftp://ftp.alsa-project.org/pub/firmware/${MY_P}.tar.bz2"

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
