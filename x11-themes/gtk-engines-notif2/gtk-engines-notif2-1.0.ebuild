# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-notif2/gtk-engines-notif2-1.0.ebuild,v 1.6 2004/06/24 23:31:24 agriffis Exp $

inherit gtk-engines2

IUSE=""
DESCRIPTION="GTK+1 Notif2 Theme Engine"
HOMEPAGE="http://themes.freshmeat.net/projects/notif210/"
SRC_URI="http://download.freshmeat.net/themes/notif210/notif210-1.2.tar.gz"
KEYWORDS="x86 alpha ppc"
LICENSE="GPL-2"
SLOT="1"

DEPEND="=x11-libs/gtk+-1.2*"

S=${WORKDIR}/notif2-${PV}

src_install() {
	einstall || die
	dodoc README INSTALL ChangeLog AUTHORS COPYING
}
