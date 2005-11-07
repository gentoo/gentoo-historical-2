# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/fmtools/fmtools-1.0.ebuild,v 1.3 2005/11/07 10:40:28 flameeyes Exp $

IUSE=""

DESCRIPTION="A collection of programs for controlling v4l radio card drivers."
HOMEPAGE="http://www.stanford.edu/~blp/fmtools/"
SRC_URI="http://www.stanford.edu/~blp/fmtools/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-alpha ~amd64 -ppc ~sparc ~x86"

DEPEND=""

src_compile() {
	emake || die
}

src_install() {
	dobin fm
	dobin fmscan
	doman fm.1
	doman fmscan.1
	dodoc README CHANGES
}
