# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/tentakel/tentakel-2.2.ebuild,v 1.3 2006/12/27 15:01:05 peper Exp $

inherit distutils eutils

DESCRIPTION="Execute commands on many hosts in parallel"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
HOMEPAGE="http://tentakel.biskalar.de/"
DEPEND="dev-lang/python"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE=""
S=${WORKDIR}/${P}/py

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}/${P}
	epatch ${FILESDIR}/${P}-manpath.patch
}
