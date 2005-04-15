# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/livecd-kconfigs/livecd-kconfigs-2005.0.ebuild,v 1.3 2005/04/15 02:22:57 wolf31o2 Exp $

inherit eutils

DESCRIPTION="Gentoo Linux official release spec files"
HOMEPAGE="http://www.gentoo.org/proj/en/releng/catalyst"
SRC_URI="http://dev.gentoo.org/~wolf31o2/sources/livecd-kconfigs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dodir /usr/share/${PF}
	cp -r ${S}/* ${D}/usr/share/${PF}
}
