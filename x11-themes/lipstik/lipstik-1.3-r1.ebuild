# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/lipstik/lipstik-1.3-r1.ebuild,v 1.1 2005/09/11 12:40:51 voxus Exp $

inherit kde

KLV=18223
DESCRIPTION="Lipstik is a purified style with many options to tune your
desktop look"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=${KLV}"
SRC_URI="http://www.kde-look.org/content/files/${KLV}-${P}.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
RESTRICT="nomirror ${RESTRICT}"

need-kde 3.3

src_unpack() {
	kde_src_unpack
	cd ${S} && epatch ${FILESDIR}/${P}-lower_case.patch
}
