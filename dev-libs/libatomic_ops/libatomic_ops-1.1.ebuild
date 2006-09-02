# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libatomic_ops/libatomic_ops-1.1.ebuild,v 1.1 2006/09/02 10:47:12 flameeyes Exp $

DESCRIPTION="Implementation for atomic memory update operations"
HOMEPAGE="http://www.hpl.hp.com/research/linux/atomic_ops/"
SRC_URI="http://www.hpl.hp.com/research/linux/atomic_ops/download/${P}.tar.gz"

LICENSE="GPL-2 MIT as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	emake pkgdatadir="/usr/share/doc/${PF}" DESTDIR="${D}" install
}
