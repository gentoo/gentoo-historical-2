# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-headers/alsa-headers-9999.ebuild,v 1.1 2006/10/11 19:42:10 flameeyes Exp $

inherit eutils mercurial

DESCRIPTION="Header files for Advanced Linux Sound Architecture kernel modules"
HOMEPAGE="http://www.alsa-project.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="-*"
IUSE=""

DEPEND=""

EHG_REPO_URI="http://hg.alsa-project.org/alsa-kernel"
EHG_PROJECT="alsa-driver"

S="${WORKDIR}/alsa-kernel"

# Remove the sound symlink workaround...
pkg_setup() {
	if [[ -L "${ROOT}/usr/include/sound" ]]; then
		rm  "${ROOT}/usr/include/sound"
	fi
}

src_unpack() {
	mercurial_src_unpack

	cd "${S}"
	epatch "${FILESDIR}/${PN}-1.0.6a-user.patch"
}

src_compile() {
	einfo "No compilation neccessary"
}

src_install() {
	cd "${S}/include"
	insinto /usr/include/sound
	doins *.h || die "include failed"
}
