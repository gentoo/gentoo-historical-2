# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/varconf/varconf-0.6.2.ebuild,v 1.3 2005/02/04 17:50:38 swegener Exp $

inherit eutils

DESCRIPTION="A configuration system designed for the STAGE server."
SRC_URI="mirror://sourceforge/worldforge/${P}.tar.bz2"
HOMEPAGE="http://www.worldforge.org/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~sparc ~ppc"
IUSE=""

DEPEND="virtual/libc"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README THANKS TODO
}
