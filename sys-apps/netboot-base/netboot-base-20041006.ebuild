# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/netboot-base/netboot-base-20041006.ebuild,v 1.1 2004/10/06 18:27:01 vapier Exp $

DESCRIPTION="Baselayout for netboot systems"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~vapier/${P}.tar.bz2
	mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="netboot"

DEPEND=""

S=${WORKDIR}

pkg_setup() {
	use netboot || die "This is only for creating netboot images"
}

src_install() {
	cp -r * ${D}/
}
