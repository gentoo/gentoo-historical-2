# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/grubconfig/grubconfig-1.24.ebuild,v 1.2 2005/01/01 11:04:14 eradicator Exp $

DESCRIPTION="Simple Tool to configure Grub-Bootloader"
HOMEPAGE="http://www.tux.org/pub/people/kent-robotti/looplinux/index.html"
SRC_URI="http://www.tux.org/pub/people/kent-robotti/looplinux/${P}.tar.gz"

KEYWORDS="x86 -ppc -sparc -alpha"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
DEPEND=">=dev-util/dialog-0.7"

src_install() {
	dosbin grubconfig
	dodoc README
}
