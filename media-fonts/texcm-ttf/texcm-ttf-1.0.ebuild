# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/texcm-ttf/texcm-ttf-1.0.ebuild,v 1.16 2010/01/01 18:12:28 fauli Exp $

inherit font

DESCRIPTION="TeX's Computer Modern Fonts for MathML"
HOMEPAGE="http://www.mozilla.org/projects/mathml/fonts/"
SRC_URI="http://www.mozilla.org/projects/mathml/fonts/bakoma/${PN}.zip"

LICENSE="bakoma"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/${PN}
FONT_S=${WORKDIR}/${PN}
FONT_SUFFIX="ttf"
