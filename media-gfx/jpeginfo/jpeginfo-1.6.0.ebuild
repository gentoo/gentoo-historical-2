# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/jpeginfo/jpeginfo-1.6.0.ebuild,v 1.6 2004/06/24 22:43:50 agriffis Exp $

IUSE=""

S=${WORKDIR}/${P}
DESCRIPTION="Prints information and tests integrity of JPEG/JFIF files."
HOMEPAGE="http://www.cc.jyu.fi/~tjko/projects.html"
SRC_URI="http://www.cc.jyu.fi/~tjko/src/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc alpha ~amd64"

DEPEND=">=media-libs/jpeg-6b"

src_install() {
	make INSTALL_ROOT=${D} install || die

	dodoc COPY* README
}
