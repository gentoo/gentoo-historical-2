# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/fuse-python/fuse-python-0.2.ebuild,v 1.1 2008/04/21 19:47:01 jokey Exp $

inherit eutils distutils

KEYWORDS="~amd64 ~x86"
DESCRIPTION="Python FUSE bindings"
HOMEPAGE="http://fuse.sourceforge.net/wiki/index.php/FusePython"
SRC_URI="mirror://sourceforge/fuse/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=dev-lang/python-2.3
		>=sys-fs/fuse-2.0"

src_compile () {
	epatch "${FILESDIR}/fuse_python_accept_none.patch"
	distutils_src_compile
}
