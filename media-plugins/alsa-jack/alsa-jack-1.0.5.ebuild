# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/alsa-jack/alsa-jack-1.0.5.ebuild,v 1.2 2004/06/13 08:09:21 eradicator Exp $

IUSE=""

inherit libtool

MY_PV=${PV/_rc/rc}

DESCRIPTION="JACK pcm plugin"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/lib/alsa-lib-${MY_PV}.tar.bz2"
RESTRICT="nomirror"

SLOT="0"
KEYWORDS="~x86 ~alpha ~amd64 ~ppc -sparc"
LICENSE="GPL-2 LGPL-2.1"

DEPEND="~media-libs/alsa-lib-${PV}
	media-sound/jack-audio-connection-kit"

S=${WORKDIR}/alsa-lib-${MY_PV}

src_compile() {
	elibtoolize
	econf --enable-jack || die "./configure failed"

	cd ${S}/src/pcm/ext
	make jack || die "make on jack plugin failed"
}

src_install() {
		cd ${S}/src/pcm/ext
		make DESTDIR=${D} install-jack || die "make install on jack plugin failed"
}
