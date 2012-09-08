# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/radiotray/radiotray-9999.ebuild,v 1.4 2012/09/08 08:52:33 hwoarang Exp $

EAPI=4
PYTHON_COMPAT='python2_6 python2_7'

inherit mercurial python-distutils-ng

DESCRIPTION="Online radio streaming player"
HOMEPAGE="http://radiotray.sourceforge.net/"
SRC_URI=""
EHG_REPO_URI="http://radiotray.hg.sourceforge.net:8000/hgroot/radiotray/radiotray"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS=""
IUSE=""

LANGS="ca de el en_GB es fi fr gl gu hu it ko lt pl pt_BR pt ro ru sk sl sv te
tr uk zh_CN"

for x in ${LANGS}; do
	IUSE="${IUSE} linguas_${x}"
done

RDEPEND="dev-python/gst-python
	dev-python/pygtk
	dev-python/lxml
	dev-python/pyxdg
	dev-python/pygobject:2
	dev-python/notify-python
	media-libs/gst-plugins-good
	media-libs/gst-plugins-ugly
	media-plugins/gst-plugins-alsa
	media-plugins/gst-plugins-libmms
	media-plugins/gst-plugins-ffmpeg
	media-plugins/gst-plugins-mad
	media-plugins/gst-plugins-ogg
	media-plugins/gst-plugins-soup
	media-plugins/gst-plugins-vorbis"

DEPEND="${RDEPEND}"

DOCS="AUTHORS CONTRIBUTORS NEWS README"

S="${WORKDIR}"/${PN}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs -r 2 .
	distutils_src_prepare
	# remove LINUGAS file so we can create our
	rm "${S}"/po/LINGUAS
	for x in ${LANGS}; do
		use "linguas_${x}" && echo "${x}" >> "${S}"/po/LINGUAS
		! use "linguas_${x}" && rm "${S}"/po/${x}.po
	done
}
