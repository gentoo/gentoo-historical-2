# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cjkcodecs/cjkcodecs-1.1.1.ebuild,v 1.7 2005/07/07 19:07:41 corsair Exp $

inherit distutils

DESCRIPTION="Python Codecs for CJK Encodings. Aimed at replacing ChineseCodecs, JapaneseCodecs and KoreanCodecs"
HOMEPAGE="http://cjkpython.i18n.org/"
SRC_URI="http://download.berlios.de/cjkpython/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc-macos ppc64 x86"
IUSE=""

DEPEND=">=dev-lang/python-2.1"
DOCS="doc/*"

src_test() {
	cd tests
	python testall.py || die "testall.py failed"
}
