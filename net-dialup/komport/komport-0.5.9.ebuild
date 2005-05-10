# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/komport/komport-0.5.9.ebuild,v 1.7 2005/05/10 17:25:01 carlo Exp $

inherit kde

DESCRIPTION="Komport - Serial port communications and vt102 terminal emulator for KDE"
HOMEPAGE="http://komport.sourceforge.net/"
SRC_URI="mirror://sourceforge/komport/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""

need-kde 3

src_unpack() {
	kde_src_unpack
	epatch ${FILESDIR}/${P}-configure-arts.diff
}