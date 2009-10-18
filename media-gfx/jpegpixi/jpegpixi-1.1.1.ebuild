# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/jpegpixi/jpegpixi-1.1.1.ebuild,v 1.5 2009/10/18 12:55:56 ssuominen Exp $

DESCRIPTION="almost lossless JPEG pixel interpolator, for correcting digital camera defects."
HOMEPAGE="http://www.zero-based.org/software/jpegpixi/"
SRC_URI="http://www.zero-based.org/software/jpegpixi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="media-libs/jpeg"
DEPEND="${RDEPEND}"

src_install() {
	dobin jpegpixi jpeghotp || die
	doman man/jpegpixi.1 man/jpeghotp.1
	dodoc AUTHORS NEWS README README.jpeglib ChangeLog
}
