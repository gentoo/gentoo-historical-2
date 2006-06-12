# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/quodlibet/quodlibet-0.21.ebuild,v 1.2 2006/06/12 23:53:41 weeve Exp $

inherit eutils python

DESCRIPTION="Quod Libet is a GTK+-based audio player written in Python."
HOMEPAGE="http://www.sacredchao.net/quodlibet/"
SRC_URI="http://www.sacredchao.net/~piman/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="aac alsa esd flac gnome mad musepack oss vorbis"

DEPEND=">=virtual/python-2.4
	>=dev-python/pygtk-2.8
	>=x11-libs/gtk+-2.8
	>=media-libs/mutagen-1.4
	>=media-libs/gstreamer-0.10.3
	>=media-libs/gst-plugins-base-0.10.3
	>=media-libs/gst-plugins-good-0.10.2
	>=dev-python/gst-python-0.10.2
	>=media-plugins/gst-plugins-gconf-0.10.3
	mad? ( >=media-plugins/gst-plugins-mad-0.10.2 )
	vorbis? ( >=media-plugins/gst-plugins-vorbis-0.10.2
		>=media-plugins/gst-plugins-ogg-0.10.2 )
	flac? ( >=media-plugins/gst-plugins-flac-0.10.2 )
	aac? ( >=media-plugins/gst-plugins-faad-0.10.1
		dev-python/ctypes )
	musepack? ( >=media-plugins/gst-plugins-musepack-0.10.0
		dev-python/ctypes )
	alsa? ( >=media-plugins/gst-plugins-alsa-0.10.2 )
	oss? ( >=media-plugins/gst-plugins-oss-0.10.2 )
	esd? ( >=media-plugins/gst-plugins-esd-0.10.2 )
	gnome? ( dev-python/gnome-python-extras
		>=media-plugins/gst-plugins-gnomevfs-0.10.2
		dev-python/feedparser )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PN}-0.17.1-multilibfix.patch
	epatch ${FILESDIR}/${PN}-0.21-ctypes.patch
}

src_compile() {
	emake extensions || die "emake extensions failed"
}

src_install() {
	make PREFIX=/usr DESTDIR=${D} libdir=$(get_libdir) install ||
		die "install failed"
	dodoc README NEWS
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}

	if ! use mad; then
		einfo ""
		einfo "MAD decoding library is disabled."
		einfo "This means that playing mp3 will not be possible."
		einfo "For mp3 playback, please add the mad USE flag."
	fi

	einfo ""
	einfo "Installing Quod Libet from an ebuild is not supported"
	einfo "upstream. If you encounter any problems, file bugs on"
	einfo "bugs.gentoo.org. DO NOT USE THE UPSTREAM BUG SYSTEM."
	einfo ""
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
