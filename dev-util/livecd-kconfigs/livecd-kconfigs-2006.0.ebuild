# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/livecd-kconfigs/livecd-kconfigs-2006.0.ebuild,v 1.1 2006/09/01 23:44:41 wolf31o2 Exp $

DESCRIPTION="Gentoo Linux official release spec files"
HOMEPAGE="http://www.gentoo.org/proj/en/releng/catalyst"
SRC_URI="http://dev.gentoo.org/~wolf31o2/sources/livecd-kconfigs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	insinto /usr/share/${PF}
	doins -r ${S}/*
}
