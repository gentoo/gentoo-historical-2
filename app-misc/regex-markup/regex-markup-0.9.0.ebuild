# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/regex-markup/regex-markup-0.9.0.ebuild,v 1.3 2004/06/24 22:29:50 agriffis Exp $

DESCRIPTION="A tool to color syslog files as well"
SRC_URI="http://www.student.lu.se/~nbi98oli/src/${P}.tar.gz"
HOMEPAGE="http://www.student.lu.se/~nbi98oli"

SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"

DEPEND="virtual/glibc"
RDEPEND=""
IUSE=""

S="${WORKDIR}/${P}"

src_compile()
{
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README TODO
}
