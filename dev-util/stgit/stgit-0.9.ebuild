# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/stgit/stgit-0.9.ebuild,v 1.1 2006/04/08 11:18:18 ferdy Exp $

inherit distutils

DESCRIPTION="Manage a stack of patches using GIT as a backend"
HOMEPAGE="http://www.procode.org/stgit/"
SRC_URI="http://homepage.ntlworld.com/cmarinas/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-util/git-1.1.0"

src_install() {
	sed -i -e 's-\(prefix:\) ~-\1 /usr-' setup.cfg
	distutils_src_install
	dodir /usr/share/doc/${PF}
	mv ${D}/usr/share/${PN}/examples ${D}/usr/share/doc/${PF}
	rmdir ${D}/usr/share/doc/${PN}
}
