# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libraw1394/libraw1394-1.1.0.ebuild,v 1.1 2005/02/12 20:07:33 vapier Exp $

DESCRIPTION="library that provides direct access to the IEEE 1394 bus"
HOMEPAGE="http://sourceforge.net/projects/libraw1394/"
SRC_URI="mirror://sourceforge/libraw1394/${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
