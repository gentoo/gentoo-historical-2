# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/quodlibet/quodlibet-2.1.ebuild,v 1.1 2009/07/16 15:47:07 ssuominen Exp $

EAPI=2
NEED_PYTHON=2.6
inherit distutils python eutils

DESCRIPTION="Quod Libet is a GTK+-based audio player written in Python."
HOMEPAGE="http://code.google.com/p/quodlibet/"
SRC_URI="http://quodlibet.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="aac +alsa dbus esd flac gnome +gstreamer hal ipod mad musepack oss trayicon tta vorbis wma xine"

COMMON_DEPEND=">=dev-python/pygtk-2.12"
RDEPEND="${COMMON_DEPEND}
	>=media-libs/mutagen-1.16
	gstreamer? ( media-libs/gst-plugins-good:0.10
		dev-python/gst-python:0.10
		mad? ( media-plugins/gst-plugins-mad:0.10 )
		vorbis? ( media-plugins/gst-plugins-vorbis:0.10
			media-plugins/gst-plugins-ogg:0.10 )
		flac? ( media-plugins/gst-plugins-flac:0.10 )
		aac? ( media-plugins/gst-plugins-faad:0.10 )
		musepack? ( media-plugins/gst-plugins-musepack:0.10 )
		wma? ( media-plugins/gst-plugins-ffmpeg:0.10
			media-libs/gst-plugins-ugly:0.10 )
		tta? ( =media-libs/gst-plugins-bad-0.10* )
		alsa? ( media-plugins/gst-plugins-alsa:0.10 )
		oss? ( media-plugins/gst-plugins-oss:0.10 )
		esd? ( media-plugins/gst-plugins-esd:0.10 ) )
	xine? ( >=media-libs/xine-lib-1.1
		dev-python/ctypes )
	gnome? ( dev-python/gnome-python-extras
		gstreamer? ( media-plugins/gst-plugins-gconf:0.10
			media-plugins/gst-plugins-gnomevfs:0.10 )
		dev-python/feedparser )
	hal? ( sys-apps/hal )
	dbus? ( >=dev-python/dbus-python-0.71 )
	ipod? ( >=media-libs/libgpod-0.5.2[python] )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool"
PDEPEND="trayicon? ( media-plugins/quodlibet-trayicon )"

pkg_setup() {
	if ! use gstreamer && ! use xine; then
		eerror "You must have either gstreamer or xine USE flag enabled."
		die "No backend USE flag enabled."
	fi
}

src_prepare() {
	if ! use gstreamer && use xine; then
		sed -i -e 's/gstbe/xinebe/' quodlibet/config.py || die "sed failed"
	fi

	if ! use gnome && use alsa; then
		sed -e 's/"gst_pipeline": ""/"gst_pipeline": "alsasink"/' \
			-i quodlibet/config.py || die "sed failed"
	fi
}

src_install() {
	${python} setup.py install --prefix="${D}/usr" \
		--no-compile "$@" || die "${python} setup.py install failed"

	dodoc HACKING NEWS README
	doicon quodlibet/images/{exfalso,quodlibet}.{png,svg}
}
