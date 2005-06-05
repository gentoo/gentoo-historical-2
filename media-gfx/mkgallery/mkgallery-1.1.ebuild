# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/mkgallery/mkgallery-1.1.ebuild,v 1.8 2005/06/05 12:17:28 hansmi Exp $

DESCRIPTION="Creates thumbnails and a HTML index file for a directory of jpg files"
HOMEPAGE="http://mkgallery.sourceforge.net/"
SRC_URI="http://mkgallery.sourceforge.net/${PN}-${PV}.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""
SLOT="0"

DEPEND="media-gfx/imagemagick"

src_install() {
	dobin mkgallery
	dodoc BUGS README THANKS TODO
}
