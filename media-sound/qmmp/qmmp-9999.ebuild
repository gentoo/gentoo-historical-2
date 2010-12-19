# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qmmp/qmmp-9999.ebuild,v 1.14 2010/12/19 03:19:50 ssuominen Exp $

EAPI="2"

inherit cmake-utils
[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="Qt4-based audio player with winamp/xmms skins support"
HOMEPAGE="http://qmmp.ylsoftware.com/index_en.php"
if [ "$PV" != "9999" ]; then
	SRC_URI="http://qmmp.ylsoftware.com/files/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	SRC_URI=""
	ESVN_REPO_URI="http://qmmp.googlecode.com/svn/trunk/qmmp/"
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS further up
IUSE="aac +alsa +dbus bs2b cdda cover enca ffmpeg flac jack kde ladspa
libsamplerate lyrics +mad mms modplug mplayer mpris musepack notifier oss
projectm pulseaudio scrobbler sndfile tray udev +vorbis wavpack"

RDEPEND="x11-libs/qt-qt3support:4
	media-libs/taglib
	alsa? ( media-libs/alsa-lib )
	bs2b? ( media-libs/libbs2b )
	cdda? ( dev-libs/libcdio )
	dbus? ( sys-apps/dbus )
	aac? ( media-libs/faad2 )
	enca? ( app-i18n/enca )
	flac? ( media-libs/flac )
	ladspa? ( media-libs/ladspa-cmt )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad )
	mms? ( media-libs/libmms )
	mplayer? ( media-video/mplayer )
	musepack? ( >=media-sound/musepack-tools-444 )
	modplug? ( >=media-libs/libmodplug-0.8.4 )
	vorbis? ( media-libs/libvorbis
		media-libs/libogg )
	jack? ( media-sound/jack-audio-connection-kit
		media-libs/libsamplerate )
	ffmpeg? ( media-video/ffmpeg )
	projectm? ( media-libs/libprojectm
		x11-libs/qt-opengl:4 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )
	udev? ( sys-fs/udisks )
	wavpack? ( media-sound/wavpack )
	scrobbler? ( net-misc/curl )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog README"

CMAKE_IN_SOURCE_BUILD="1"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_use alsa)
		$(cmake-utils_use_use aac)
		$(cmake-utils_use_use bs2b)
		$(cmake-utils_use_use cover)
		$(cmake-utils_use_use cdda CDA)
		$(cmake-utils_use_use dbus)
		$(cmake-utils_use_use enca)
		$(cmake-utils_use_use ffmpeg)
		$(cmake-utils_use_use flac)
		-DUSE_HAL=OFF
		$(cmake-utils_use_use jack)
		$(cmake-utils_use_use kde KDENOTIFY)
		$(cmake-utils_use_use ladspa)
		$(cmake-utils_use_use lyrics)
		$(cmake-utils_use_use mad)
		$(cmake-utils_use_use mplayer)
		$(cmake-utils_use_use mms)
		$(cmake-utils_use_use modplug)
		$(cmake-utils_use_use mpris)
		$(cmake-utils_use_use musepack MPC)
		$(cmake-utils_use_use notifier)
		$(cmake-utils_use_use oss)
		$(cmake-utils_use_use projectm)
		$(cmake-utils_use_use pulseaudio PULSE)
		$(cmake-utils_use_use scrobbler)
		$(cmake-utils_use_use sndfile)
		$(cmake-utils_use_use tray STATICON)
		$(cmake-utils_use_use libsamplerate SRC)
		$(cmake-utils_use_use udev UDISKS)
		$(cmake-utils_use_use vorbis)
		$(cmake-utils_use_use wavpack)
		)

	cmake-utils_src_configure
}
