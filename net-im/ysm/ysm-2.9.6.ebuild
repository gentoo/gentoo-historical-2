# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ysm/ysm-2.9.6.ebuild,v 1.1 2004/08/06 19:18:32 aliz Exp $

MY_PV=${PV//./_}
DESCRIPTION="A console ICQ client supporting versions 7/8"
HOMEPAGE="http://ysmv7.sourceforge.net/"
SRC_URI="mirror://sourceforge/ysmv7/${PN}v7_${MY_PV}.tar.bz2"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="virtual/libc"
RDEPEND="virtual/libc"

S=${WORKDIR}/${PN}v7_${MY_PV}

src_install () {
	dobin src/ysm
	doman src/man/ysm.1
	dodoc README AUTHORS INSTALL
}
