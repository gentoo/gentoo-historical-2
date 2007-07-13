# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-extra/musicbox/musicbox-027-r2.ebuild,v 1.2 2007/07/13 19:03:08 armin76 Exp $

ROX_LIB_VER=2.0.0
inherit rox eutils

DESCRIPTION="MusicBox - an MP3/OGG Player for the ROX Desktop"
HOMEPAGE="http://www.hayber.us/rox/MusicBox/"
SRC_URI="http://www.hayber.us/rox/musicbox/MusicBox-027.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="mp3 vorbis alsa"

# NOTE: flac support is removed because it requires 1.1.2, and 1.1.3 is now
# being unmasked.  See bug 181864 for more info.

DEPEND="
	>=dev-python/pyao-0.81
	alsa? ( >=dev-python/pyalsaaudio-0.2 )
	mp3? (
		>=dev-python/pymad-0.4.1
		>=dev-python/pyid3lib-0.5.1 )
	vorbis? ( >=dev-python/pyvorbis-1.1 )"
#	flac? (
#		~media-libs/flac-1.1.2
#		>=dev-lang/swig-1.3.25 )"

RDEPEND="
	>=dev-python/pyao-0.81
	alsa? ( >=dev-python/pyalsaaudio-0.2 )
	mp3? (
		>=dev-python/pymad-0.4.1
		>=dev-python/pyid3lib-0.5.1 )
	vorbis? ( >=dev-python/pyvorbis-1.1 )"
#	flac? (	~media-libs/flac-1.1.2 )"

APPNAME=MusicBox
APPCATEGORY="AudioVideo;Audio;Player"
S=${WORKDIR}

src_unpack() {
	unpack ${A}
	cd "${S}"
#	if use flac; then
#		if ! built_with_use dev-lang/swig python; then
#			einfo "MusicBox flac support requires swig with python support."
#			einfo "Please rebuild swig with USE=\"python\"."
#			die "swig python support missing"
#		fi
#		epatch ${FILESDIR}/${P}-fPIC.patch
#	fi
	epatch ${FILESDIR}/${P}-mime.patch
}

# Special compilation needed for flac support
src_compile() {
#	if use flac; then
#		cd "${S}/${APPNAME}/plugins/flac"
#		make || die "flac plugin compile failed."
#	fi
	rox_src_compile
}

