# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/vanessa-logger/vanessa-logger-0.0.7.ebuild,v 1.1 2005/01/21 19:23:17 xmerlin Exp $

MY_PN="${PN/-/_}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Generic logging layer that may be used to log to one or more of syslog, an open file handle or a file name."
HOMEPAGE="http://www.vergenet.net/linux/vanessa/"
SRC_URI="http://www.vergenet.net/linux/vanessa/download/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~alpha ~ia64 ~ppc"
IUSE=""

DEPEND="virtual/libc"

S="${WORKDIR}/vanessa_logger-0.0.6"

src_install() {
	einstall
	dodoc AUTHORS NEWS README TODO sample/*.c sample/*.h
}
