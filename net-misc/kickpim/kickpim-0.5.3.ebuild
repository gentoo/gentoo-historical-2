# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/kickpim/kickpim-0.5.3.ebuild,v 1.5 2004/06/28 22:37:40 carlo Exp $

inherit kde eutils

DESCRIPTION="A KDE panel applet for editing and accessing the KDE Adressbook."
SRC_URI="mirror://sourceforge/kickpim/${P}.tar.bz2"
HOMEPAGE="http://kickpim.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

need-kde 3

src_unpack() {
	kde_src_unpack
	epatch ${FILESDIR}/${P}-fPIC.patch
}
