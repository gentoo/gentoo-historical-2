# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libmath++/libmath++-0.0.3.ebuild,v 1.9 2004/06/24 23:05:39 agriffis Exp $

DESCRIPTION="template based math library, written in C++, for symbolic and numeric calculus applications"
HOMEPAGE="http://www.surakware.net/projects/libmath%2B%2B/index.xml"
SRC_URI="ftp://ftp.surakware.net/pub/unstable/releases/libmath%2B%2B/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="x86 ppc s390"

DEPEND=""

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
