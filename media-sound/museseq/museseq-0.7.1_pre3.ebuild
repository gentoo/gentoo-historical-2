# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/museseq/museseq-0.7.1_pre3.ebuild,v 1.5 2005/11/07 11:17:33 flameeyes Exp $

inherit kde-functions virtualx eutils

MY_P=${P/museseq/muse}
MY_P=${MY_P/_/}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
SRC_URI="mirror://sourceforge/lmuse/${MY_P}.tar.bz2"
HOMEPAGE="http://lmuse.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc ladcca debug"

DEPEND="$(qt_min_version 3.2)
	>=media-libs/alsa-lib-0.9.0
	media-sound/fluidsynth
	doc? ( app-text/openjade
		   app-doc/doxygen
		   media-gfx/graphviz )
	dev-lang/perl
	>=media-libs/libsndfile-1.0.1
	>=media-libs/libsamplerate-0.1.0
	>=media-sound/jack-audio-connection-kit-0.98.0
	ladcca?		( >=media-libs/ladcca-0.4.0 )"

src_compile() {
	cd ${WORKDIR}/${MY_P}
	local myconf
	myconf="--disable-suid-build" # instead, use CONFIG_RTC and realtime-lsm
	use ladcca		|| myconf="${myconf} --disable-ladcca"
	use debug		&& myconf="${myconf} --enable-debug"
	Xeconf ${myconf} || die "configure failed"

	emake || die
}

src_install() {
	cd ${WORKDIR}/${MY_P}
	make DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README SECURITY README.*
	mv ${D}/usr/bin/muse ${D}/usr/bin/museseq
}

pkg_postinst() {
	einfo "You must have the realtime module loaded to use MusE 0.7.x"
	einfo "Additionally, configure your Linux Kernel for non-generic"
	einfo "Real Time Clock support enabled or loaded as a module."
	einfo "User must have read/write access to /dev/misc/rtc device."
	einfo "Realtime LSM: http://sourceforge.net/projects/realtime-lsm/"
}

