# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/synce-multisync_plugin/synce-multisync_plugin-0.8.2-r1.ebuild,v 1.2 2004/04/25 22:40:23 agriffis Exp $

DESCRIPTION="Multisync plugin to synchronize Windows CE devices with computers running GNU/Linux, like MS ActiveSync."
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/glibc
	>=dev-libs/check-0.8.2
	>=app-pda/synce-libsynce-0.3
	>=app-pda/synce-rra-0.8.4
	>=app-pda/multisync-0.80"

src_compile() {
	econf -with-multisync-include=/usr/include/multisync || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR="${D%/}" install || die
}
