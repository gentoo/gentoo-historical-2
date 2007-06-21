# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/gt5/gt5-1.3d.ebuild,v 1.1 2007/06/21 18:38:45 angelos Exp $

DESCRIPTION="a diff-capable 'du-browser'"
HOMEPAGE="http://gt5.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-apps/gawk
		|| ( www-client/links
		www-client/elinks
		www-client/lynx )"

src_install() {
		dobin gt5
		doman gt5.1
		dodoc Changelog README
}
