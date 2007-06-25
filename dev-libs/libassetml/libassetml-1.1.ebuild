# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libassetml/libassetml-1.1.ebuild,v 1.7 2007/06/25 17:15:24 peper Exp $

DESCRIPTION="use xml files as resource databases"
HOMEPAGE="http://ofset.sourceforge.net/"
SRC_URI="mirror://sourceforge/ofset/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="=dev-libs/glib-2*
	dev-libs/libxml2
	dev-libs/popt
	sys-apps/texinfo
	app-text/texi2html"

DEPEND="dev-util/pkgconfig
	${RDEPEND}"

src_install() {
	emake install DESTDIR=${D} || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
