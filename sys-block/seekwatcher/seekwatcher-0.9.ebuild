# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/seekwatcher/seekwatcher-0.9.ebuild,v 1.1 2007/12/14 12:58:34 robbat2 Exp $

DESCRIPTION="Seekwatcher generates graphs from blktrace runs to help visualize IO patterns and performance."
HOMEPAGE="http://oss.oracle.com/~mason/seekwatcher/"
SRC_URI="http://oss.oracle.com/~mason/seekwatcher/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/matplotlib-0.90.1
		>=sys-block/btrace-0.0.20070730162628"

src_install() {
	dobin seekwatcher
	dohtml README.html
}
