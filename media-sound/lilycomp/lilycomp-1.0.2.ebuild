# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lilycomp/lilycomp-1.0.2.ebuild,v 1.1.1.1 2005/11/30 09:38:17 chriswhite Exp $

DESCRIPTION="graphical note entry program for use with LilyPond"
HOMEPAGE="http://lilycomp.sourceforge.net/"
SRC_URI="mirror://sourceforge/lilycomp/${P/-/.}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/python"

S="${WORKDIR}/${P/-/.}"

src_install() {
	newbin lilycomp.py lilycomp || die "newbin failed"
	dohtml *.html
	dodoc [[:upper:]]*
}
