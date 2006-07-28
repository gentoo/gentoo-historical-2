# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/beaglefs/beaglefs-1.0.3.ebuild,v 1.1 2006/07/28 19:08:04 metalgod Exp $

DESCRIPTION="beaglefs implements a filesystem representing a live Beagle query."
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/rml/fuse/beaglefs/"
SRC_URI="http://www.kernel.org/pub/linux/kernel/people/rml/fuse/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-misc/beagle-0.2
	>=sys-fs/fuse-2.5"
RDEPEND=""

src_compile() {
	emake
}

src_install() {
	dobin beaglefs
	dodoc README
}

pkg_postinst() {
	einfo
	einfo "Please read /usr/share/doc/${P}/README.gz"
	einfo "to learn how to work with beaglefs"
	einfo
}
