# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-headers/alsa-headers-1.0.8_rc2.ebuild,v 1.1 2005/01/11 12:47:07 eradicator Exp $

IUSE=""

inherit eutils

MY_PV="${PV/_rc/rc}"

MY_PN=${PN/headers/driver}
MY_P="${MY_PN}-${MY_PV}"
S=${WORKDIR}/${MY_P}
MY_FILESDIR="${FILESDIR/headers/driver}"

DESCRIPTION="Header files for Advanced Linux Sound Architecture kernel modules"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/driver/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

DEPEND=""

# Remove the sound symlink workaround...
pkg_setup() {
	if [ -L /usr/include/sound ]; then
		rm  /usr/include/sound
	fi
}

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${PN}-1.0.6a-user.patch
}

src_compile() {
	einfo "No compilation neccessary"
}

src_install() {
	cd ${S}/alsa-kernel/include
	insinto /usr/include/sound
	doins *.h
}
