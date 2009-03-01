# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmaa/libmaa-1.1.1.ebuild,v 1.1 2009/03/01 09:25:31 pva Exp $

DESCRIPTION="Library with low-level data structures which are helpful for writing compilers"
HOMEPAGE="http://www.dict.org/"
SRC_URI="mirror://sourceforge/dict/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~sparc ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog NEWS README doc/libmaa.600dpi.ps || die
}
