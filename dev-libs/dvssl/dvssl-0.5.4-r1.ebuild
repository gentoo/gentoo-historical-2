# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dvssl/dvssl-0.5.4-r1.ebuild,v 1.1.1.1 2005/11/30 09:41:34 chriswhite Exp $

DESCRIPTION="dvssl provides a simple interface to openssl"
SRC_URI="http://tinfpc2.vub.ac.be/dvssl-${PVR}.tar.gz"
HOMEPAGE="http://tinf2.vub.ac.be/~dvermeir/software/dv/dvssl/html/"
KEYWORDS="~x86 ppc"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
DEPEND="virtual/libc
	dev-libs/openssl
	dev-libs/dvutil
	dev-libs/dvnet"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
