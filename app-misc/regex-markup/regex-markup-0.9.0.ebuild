# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/regex-markup/regex-markup-0.9.0.ebuild,v 1.6 2005/01/01 15:20:36 eradicator Exp $

DESCRIPTION="A tool to color syslog files as well"
HOMEPAGE="http://www.student.lu.se/~nbi98oli"
SRC_URI="http://www.student.lu.se/~nbi98oli/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND="virtual/libc"
RDEPEND=""

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
