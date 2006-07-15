# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/nopaste/nopaste-1252.ebuild,v 1.4 2006/07/15 23:27:06 tsunam Exp $

DESCRIPTION="command-line interface to rafb.net/paste"
HOMEPAGE="http://gentoo.org/~agriffis/nopaste/"
SRC_URI="${HOMEPAGE}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc x86 ~x86-fbsd"
IUSE="X"

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/ruby
	X? ( || ( x11-misc/xclip x11-misc/xcut ) )"

S=${WORKDIR}

src_install() {
	newbin ${DISTDIR}/${P} ${PN}
}
