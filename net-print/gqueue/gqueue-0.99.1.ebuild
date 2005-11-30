# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/gqueue/gqueue-0.99.1.ebuild,v 1.1.1.1 2005/11/30 09:48:20 chriswhite Exp $

DESCRIPTION="Gnome frontend for cups queues. It shows the printing jobs queue and let you remove some jobs."
SRC_URI="http://web.tiscali.it/diegobazzanella/${P}.tar.gz"
HOMEPAGE="http://web.tiscali.it/diegobazzanella/"

S=${WORKDIR}/gqueue

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=net-print/cups-1.1.14
	>=gnome-base/libgnomeui-2.0.0"

src_install() {
	einstall || die
	dodoc AUTHORS COPYING
}
