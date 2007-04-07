# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wgetpaste/wgetpaste-1.1.ebuild,v 1.5 2007/04/07 00:58:12 jer Exp $

DESCRIPTION="Command-line interface to rafb.net/paste using only wget"
HOMEPAGE="http://zlin.dk/"
SRC_URI="${HOMEPAGE}/${PF}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/sed
		net-misc/wget"

src_install() {
	newbin "${DISTDIR}/${PF}" "${PN}"
}
