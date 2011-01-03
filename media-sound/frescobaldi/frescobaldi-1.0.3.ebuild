# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/frescobaldi/frescobaldi-1.0.3.ebuild,v 1.1 2011/01/03 20:28:43 dilfridge Exp $

EAPI="2"

KDE_LINGUAS="cs de es fr gl it nl pl ru tr"
PYTHON_DEPEND="2"
inherit python kde4-base

DESCRIPTION="a LilyPond sheet music text editor for KDE"
HOMEPAGE="http://www.frescobaldi.org/"
SRC_URI="http://lilykde.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="+handbook"

DEPEND="
	>=kde-base/pykde4-${KDE_MINIMAL}
	media-gfx/imagemagick
	media-sound/lilypond
"
RDEPEND=${DEPEND}

PATCHES=( "${FILESDIR}/${P}"-python27.patch )

pkg_setup() {
	python_set_active_version 2
	kde4-base_pkg_setup
}

src_install() {
	kde4-base_src_install
	find "${D}" -type f -name '*.pyc' -exec rm -f {} +
}
