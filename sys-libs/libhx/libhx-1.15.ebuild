# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libhx/libhx-1.15.ebuild,v 1.1 2008/04/06 17:46:10 hanno Exp $

DESCRIPTION="Platform independent library providing basic system functions."
HOMEPAGE="http://jengelh.hopto.org/f/libHX/"
SRC_URI="http://jengelh.hopto.org/f/libHX/libHX-${PV}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="virtual/libc"
S="${WORKDIR}/libHX-${PV}"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc doc/* || die
}
