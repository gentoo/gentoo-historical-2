# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/sub2srt/sub2srt-0.5.3.ebuild,v 1.3 2005/10/31 01:41:53 halcy0n Exp $

DESCRIPTION="Tool to convert several subtitle formats into subviewer srt"
HOMEPAGE="http://www.robelix.com/sub2srt/"
SRC_URI="http://www.robelix.com/sub2srt/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

IUSE=""
RDEPEND="dev-lang/perl"

src_install() {
	dobin sub2srt
	dodoc README
}
