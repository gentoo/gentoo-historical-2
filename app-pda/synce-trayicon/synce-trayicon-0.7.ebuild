# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/synce-trayicon/synce-trayicon-0.7.ebuild,v 1.2 2003/09/06 22:21:40 msterret Exp $

DESCRIPTION="Synchronize Windows CE devices with computers running GNU/Linux, like MS ActiveSync."
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome"

DEPEND="virtual/glibc
	app-pda/synce-librapi2
	>=x11-libs/gtk+-2.0*
	>=gnome-base/libgnomeui-2.0*"

src_compile() {
	econf
	emake || die
}

src_install() {
	make DESTDIR="${D%/}" install || die
}
