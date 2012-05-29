# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/audioread/audioread-0.6.ebuild,v 1.1 2012/05/29 12:30:42 sochotnicky Exp $

EAPI=4

inherit distutils

DESCRIPTION="Module for decoding audio files using whichever backend is available"
HOMEPAGE="http://pypi.python.org/pypi/audioread"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="|| ( dev-python/gst-python dev-python/pymad media-video/ffmpeg )"
RDEPEND="${DEPEND}"

pkg_postinst() {
		elog "You might need to enable additional USE flags in backends to"
		elog "decode some types of audio files. Priority of backends:"
		elog "   * gstreamer"
		elog "   * mad"
		elog "   * ffmpeg"
}
