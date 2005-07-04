# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/kdar/kdar-2.0.5.ebuild,v 1.2 2005/07/04 07:10:53 robbat2 Exp $

inherit kde

DESCRIPTION="KDE Disk Archiver."
HOMEPAGE="http://kdar.sourceforge.net/"
SRC_URI="mirror://sourceforge/kdar/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc"
IUSE="dar32 dar64"

DEPEND=">=app-backup/dar-2.2.0
	>=app-arch/bzip2-1.0.2
	>=sys-libs/zlib-1.1.4"

need-kde 3.3

src_compile() {
	local myconf
	use dar32 && myconf="${myconf} --enable-mode=32"
	use dar64 && myconf="${myconf} --enable-mode=64"
	kde_src_compile
}
