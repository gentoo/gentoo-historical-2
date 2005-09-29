# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/acdctl/acdctl-1.1.ebuild,v 1.4 2005/09/29 16:24:30 hansmi Exp $

DESCRIPTION="Apple Cinema Display Control"
HOMEPAGE="http://www.technocage.com/~caskey/acdctl/"
SRC_URI="http://www.technocage.com/~caskey/acdctl/download/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc"
IUSE=""
DEPEND="dev-libs/libusb"

src_install() {
	dobin acdctl
	dodoc CHANGELOG README
}
