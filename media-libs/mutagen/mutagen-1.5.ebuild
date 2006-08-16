# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mutagen/mutagen-1.5.ebuild,v 1.3 2006/08/16 00:37:28 tcort Exp $

inherit distutils

DESCRIPTION="Mutagen is an audio metadata tag reader and writer implemented in pure Python."
HOMEPAGE="http://www.sacredchao.net/quodlibet/wiki/Development/Mutagen"
SRC_URI="http://www.sacredchao.net/~piman/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="test"

DEPEND="test? (
		dev-python/eyeD3
		dev-python/pyvorbis
		media-libs/flac
		media-sound/vorbis-tools
	)
	>=virtual/python-2.4"

RDEPEND=">=virtual/python-2.4"

src_test() {
	python setup.py test || die "src_test failed."
}
