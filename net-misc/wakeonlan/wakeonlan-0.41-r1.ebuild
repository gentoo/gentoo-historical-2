# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/wakeonlan/wakeonlan-0.41-r1.ebuild,v 1.6 2007/04/17 20:10:14 welp Exp $

inherit eutils perl-app

DESCRIPTION="Client for Wake-On-LAN"
HOMEPAGE="http://gsd.di.uminho.pt/jpo/software/wakeonlan/"
SRC_URI="http://gsd.di.uminho.pt/jpo/software/wakeonlan/downloads/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86 ~x86-fbsd"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-ethers-lookup.patch
}
