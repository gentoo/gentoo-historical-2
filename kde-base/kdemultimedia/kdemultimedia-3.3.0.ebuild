# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdemultimedia/kdemultimedia-3.3.0.ebuild,v 1.6 2004/08/30 15:45:01 pvdabeel Exp $

inherit kde-dist flag-o-matic eutils

DESCRIPTION="KDE multimedia apps: noatun, kscd, artsbuilder..."

KEYWORDS="~x86 ~amd64 ~sparc ppc"
IUSE="alsa audiofile cdparanoia encode flac oggvorbis speex xine"

DEPEND="~kde-base/kdebase-${PV}
	audiofile? ( media-libs/audiofile )
	cdparanoia? ( media-sound/cdparanoia )
	flac? ( media-libs/flac )
	encode? ( media-sound/lame )
	oggvorbis? ( media-sound/vorbis-tools )
	xine? ( >=media-libs/xine-lib-1_beta12 )
	alsa? ( media-libs/alsa-lib )
	speex? ( media-libs/speex )
	media-libs/taglib media-libs/tunepimp
	!media-sound/juk"

src_unpack() {
	kde_src_unpack
	epatch ${FILESDIR}/3.3.0-Makefile.am.diff
	epatch ${FILESDIR}/3.3.0-Makefile-synth.am.diff
	cd ${S} && make -f admin/Makefile.common
}

src_compile() {
	replace-flags -O3 -O2
	# Still persists with 3.2.1 - kaboodle
	filter-flags "-fno-default-inline"

	use xine && myconf="$myconf --with-xine-prefix=/usr"
	use xine || DO_NOT_COMPILE="$DO_NOT_COMPILE xine_artsplugin"

	myconf="${myconf} `use_with cdparanoia`"

	# make -j2 fails, at least on ppc
	use ppc && export MAKEOPTS="$MAKEOPTS -j1"
	use hppa && append-flags -ffunction-sections

	# alsa 0.9 not supported
	use alsa	&& myconf="$myconf --with-alsa --with-arts-alsa" || myconf="$myconf --without-alsa --disable-alsa"
	use oggvorbis	&& myconf="$myconf --with-vorbis=/usr"		|| myconf="$myconf --without-vorbis"
	use encode	&& myconf="$myconf --with-lame=/usr" || myconf="$myconf --without-lame"

	myconf="$myconf --disable-strict --disable-warnings"

	kde_src_compile
}
