# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/desktop-file-utils/desktop-file-utils-0.3.ebuild,v 1.3 2004/01/17 03:25:46 darkspecter Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Command line utilities to work with desktop menu entries"
SRC_URI="http://www.freedesktop.org/software/desktop-file-utils/releases/${P}.tar.gz"
HOMEPAGE="http://www.freedesktop.org/software/desktop-file-utils/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"
IUSE=""

RDEPEND=">=dev-libs/glib-2.0.0
		>=dev-libs/popt-1.6.3"

DEPEND="${RDEPEND}
		dev-util/pkgconfig"


src_compile() {
	econf || die
	emake || die
}

src_install() {
	make prefix=${D}/usr					\
	     sysconfdir=${D}/etc				\
	     localstatedir=${D}/var/lib			\
	     install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README
}

