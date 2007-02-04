# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/exaile/exaile-0.2.8.ebuild,v 1.3 2007/02/04 11:49:05 drac Exp $

inherit eutils toolchain-funcs

MY_P=${PN}_${PV}

DESCRIPTION="a media player aiming to be similar to KDE's AmaroK, but for GTK"
HOMEPAGE="http://www.exaile.org/"
SRC_URI="http://www.exaile.org/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="aac cdaudio fam flac gnome ipod libnotify libsexy mp3 musepack ogg
	serpentine streamripper vorbis"

RDEPEND=">=dev-lang/python-2.4
	>=dev-python/pygtk-2.8.6
	>=dev-python/pysqlite-2
	>=media-libs/gstreamer-0.10
	>=media-libs/gst-plugins-good-0.10
	>=media-plugins/gst-plugins-gnomevfs-0.10
	>=dev-python/gst-python-0.10
	>=media-libs/mutagen-1.6
	>=media-plugins/gst-plugins-gconf-0.10
	dev-python/elementtree
	dev-python/dbus-python
	fam? ( app-admin/gamin )
	mp3? ( >=media-plugins/gst-plugins-mad-0.10 )
	ogg? ( >=media-plugins/gst-plugins-ogg-0.10 )
	vorbis? ( >=media-plugins/gst-plugins-vorbis-0.10 )
	flac? ( >=media-plugins/gst-plugins-flac-0.10 )
	aac? ( >=media-plugins/gst-plugins-faad-0.10 )
	libnotify? ( dev-python/notify-python )
	libsexy? ( dev-python/sexy-python )
	musepack? ( >=media-plugins/gst-plugins-musepack-0.10 )
	gnome? ( dev-python/gnome-python-extras )
	ipod? ( >=media-libs/libgpod-0.3.2-r1
		>=media-plugins/gst-plugins-faad-0.10 )
	cdaudio? ( media-plugins/gst-plugins-cdparanoia
	dev-python/cddb-py )
	serpentine? ( app-cdr/serpentine )
	streamripper? ( media-sound/streamripper )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use ipod && ! built_with_use media-libs/libgpod python ; then
		eerror "libgpod has to be built with python support"
		die "libgpod python use-flag not set"
	fi
}

src_unpack() {
	cd "${S}"
	unpack ${A}
	epatch "${FILESDIR}"/${P}-strip.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
