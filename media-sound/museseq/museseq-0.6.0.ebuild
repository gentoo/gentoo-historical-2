# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/museseq/museseq-0.6.0.ebuild,v 1.6 2004/06/25 00:15:05 agriffis Exp $

inherit virtualx

MY_P=muse-${PV}
DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
HOMEPAGE="http://muse.seh.de"
SRC_URI="http://muse.seh.de/bin/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="jack fluidsynth ladcca"

DEPEND="media-libs/alsa-lib \
	>=media-libs/libsndfile-1.0.4 \
	>=x11-libs/qt-3.1.0
	ladcca? ( media-libs/ladcca ) \
	jack? ( media-sound/jack-audio-connection-kit ) \
	fluidsynth? ( media-sound/fluidsynth )"

S=${WORKDIR}/${MY_P}

src_compile() {
	local myconf
	use ladcca || myconf="${myconf} --disable-ladcca"
	use jack || myconf="${myconf} --disable-jack"
	use fluidsynth || myconf="${myconf} --disable-fluidsynth"
	Xeconf ${myconf} || die "configure failed"

	# Allow access to /dev/dri/card*          
	addpredict /dev/dri/card*

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc COPYING INSTALL README README.softsynth SECURITY TODO

	# Name conflict with media-sound/muse.  See bug #34973
	mv ${D}/usr/bin/muse ${D}/usr/bin/lmuse

	if [ ! -f /usr/bin/muse -o -L /usr/bin/muse ]; then
		dosym /usr/bin/lmuse /usr/bin/muse
	fi
}

pkg_postinst() {
	einfo ""
	einfo "Muse has been installed normally. If,"
	einfo "you would like to use muse with real time"
	einfo "time capabilities for the sequencer then do"
	einfo "chmod 4755 /usr/bin/lmuse"
	einfo ""
	einfo "Muse can use /dev/rtc if it is compiled in"
	einfo "to your kernel, or available as a module."
	einfo ""
}

