# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-headers/alsa-headers-1.0.6a.ebuild,v 1.5 2004/09/22 22:35:54 eradicator Exp $

IUSE=""

inherit eutils

MY_PN=${PN/headers/driver}
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

MY_FILESDIR="${FILESDIR/headers/driver}"

DESCRIPTION="Header files for Advanced Linux Sound Architecture kernel modules"
HOMEPAGE="http://www.alsa-project.org/"
LICENSE="GPL-2 LGPL-2.1"

DEPEND=""

SLOT="0"
KEYWORDS="x86 ~ppc ~sparc amd64 ~alpha ia64 ~ppc64 ~hppa"

SRC_URI="mirror://alsaproject/driver/${MY_P}.tar.bz2"

# Remove the sound symlink workaround...
pkg_setup() {
	if [ -L /usr/include/sound ]; then
		rm  /usr/include/sound
	fi
}

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${MY_FILESDIR}/${MY_PN}-1.0.5-devfix.patch
	epatch ${MY_FILESDIR}/${MY_PN}-1.0.5a-cs46xx-passthrough.patch
	epatch ${FILESDIR}/${P}-user.patch
}

src_compile() {
	einfo "No compilation neccessary"
}


src_install() {
	cd ${S}/alsa-kernel/include
	insinto /usr/include/sound
	doins *.h
}
