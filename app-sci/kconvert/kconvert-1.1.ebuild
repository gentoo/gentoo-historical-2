# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/kconvert/kconvert-1.1.ebuild,v 1.3 2004/04/19 10:26:16 phosphan Exp $

DESCRIPTION="Converting Toolbetween Metric and Imperial"
HOMEPAGE="http://apps.kde.com/na/2/counter/vid/5632/kcurl"
SRC_URI="http://ftp.kde.com/Math_Science/KConvert/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/glibc"

S=${WORKDIR}/${PN}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL README TODO
}
