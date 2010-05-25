# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/radiotray/radiotray-9999.ebuild,v 1.1 2010/05/25 13:00:12 hwoarang Exp $

EAPI=3
PYTHON_DEPEND="2"

inherit mercurial distutils

DESCRIPTION="Online radio streaming player"
HOMEPAGE="http://radiotray.sourceforge.net/"
SRC_URI=""
EHG_REPO_URI="http://radiotray.hg.sourceforge.net/hgweb/radiotray/"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/gst-python
	dev-python/pygtk
	dev-python/lxml
	dev-python/pyxdg
	dev-python/pygobject
	dev-python/pyinotify
	media-plugins/gst-plugins-libmms
	media-plugins/gst-plugins-ffmpeg
	media-plugins/gst-plugins-mad
	media-plugins/gst-plugins-ogg
	media-plugins/gst-plugins-vorbis"

DEPEND="${RDEPEND}"

DOCS="AUTHORS CONTRIBUTORS NEWS README"

S="${WORKDIR}"/${PN}

src_prepare() {
	python_convert_shebangs -r 2 .
	distutils_src_prepare
}
