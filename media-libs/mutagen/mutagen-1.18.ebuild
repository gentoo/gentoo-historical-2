# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/mutagen/mutagen-1.18.ebuild,v 1.7 2010/01/15 09:44:36 fauli Exp $

EAPI=2
inherit distutils

DESCRIPTION="Mutagen is an audio metadata tag reader and writer implemented in pure Python."
HOMEPAGE="http://code.google.com/p/mutagen"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=">=dev-lang/python-2.4"
DEPEND="${RDEPEND}
	test? (	dev-python/eyeD3
		dev-python/pyvorbis
		media-libs/flac[ogg]
		media-sound/vorbis-tools )"

DOCS="API-NOTES NEWS README TODO TUTORIAL"

src_test() {
	${python} setup.py test || die "src_test failed"
}
