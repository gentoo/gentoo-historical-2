# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/streamtuner-python/streamtuner-python-0.1.2.ebuild,v 1.1 2004/06/08 03:48:12 eradicator Exp $

DESCRIPTION="A plugin for Streamtuner that provides an embedded Python interpreter."
SRC_URI="http://savannah.nongnu.org/download/streamtuner/${P}.tar.gz"
HOMEPAGE="http://www.nongnu.org/streamtuner/"

IUSE=""
SLOT="0"
KEYWORDS="~x86 ~ppc"
LICENSE="BSD"

DEPEND=">=net-misc/streamtuner-0.12.0
	>=dev-lang/python-2.0"

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog NEWS README INSTALL
}
