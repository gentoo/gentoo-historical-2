# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/jsmath/jsmath-1.0.ebuild,v 1.1 2009/11/12 18:03:03 bicatali Exp $

inherit font

MYPN=TeX-fonts-linux

DESCRIPTION="Raster fonts for jsmath"
HOMEPAGE="http://www.math.union.edu/~dpvc/jsMath/"
SRC_URI="http://www.math.union.edu/~dpvc/jsMath/download/${MYPN}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MYPN}"
FONT_PN="jsMath"
FONT_SUFFIX="ttf"
