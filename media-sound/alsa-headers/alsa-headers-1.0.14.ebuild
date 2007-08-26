# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-headers/alsa-headers-1.0.14.ebuild,v 1.4 2007/08/26 20:20:05 jurek Exp $

inherit eutils

MY_PN=${PN/headers/driver}
MY_P="${MY_PN}-${PV/_rc/rc}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Header files for Advanced Linux Sound Architecture kernel modules"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/driver/${MY_P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh sparc x86"
IUSE=""

DEPEND=""

RESTRICT="binchecks strip"

# Remove the sound symlink workaround...
pkg_setup() {
	if [[ -L "${ROOT}/usr/include/sound" ]]; then
		rm	"${ROOT}/usr/include/sound"
	fi
}

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${PN}-1.0.6a-user.patch"
}

src_compile() { :; }

src_install() {
	cd "${S}/alsa-kernel/include"
	insinto /usr/include/sound
	doins *.h || die "include failed"
}
