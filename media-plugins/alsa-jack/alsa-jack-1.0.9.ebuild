# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/alsa-jack/alsa-jack-1.0.9.ebuild,v 1.7 2005/12/14 15:35:24 fvdpol Exp $

inherit libtool

DESCRIPTION="JACK pcm plugin. Allows native ALSA applications to connect to the jackd. Works transparantly for both capture and playback."
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/plugins/alsa-plugins-${PV}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 -sparc x86"
IUSE=""

DEPEND="~media-libs/alsa-lib-${PV}
	media-sound/jack-audio-connection-kit"

S=${WORKDIR}/alsa-plugins-${PV}

src_compile() {
	econf || die "configure failed"

	cd ${S}/pcm/jack
	emake || die "make on jack plugin failed"
}

src_install() {
	cd ${S}/pcm/jack
	make DESTDIR="${D}" install || die "make install on jack plugin failed"

	dodoc README
}
