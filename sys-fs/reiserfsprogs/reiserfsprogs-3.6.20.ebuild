# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/reiserfsprogs/reiserfsprogs-3.6.20.ebuild,v 1.2 2006/11/07 01:11:36 vapier Exp $

DESCRIPTION="Reiserfs Utilities"
HOMEPAGE="http://www.namesys.com/"
SRC_URI="http://www.namesys.com/pub/reiserfsprogs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# big endian has broken code (doesnt compile) #154294
KEYWORDS="~alpha ~amd64 ~arm -hppa ~ia64 -mips -ppc -ppc64 -sparc ~x86"
IUSE=""

src_compile() {
	econf --prefix=/ || die "Failed to configure"
	emake || die "Failed to compile"
}

src_install() {
	emake DESTDIR="${D}" install || die "Failed to install"
	dodoc ChangeLog INSTALL README
}
