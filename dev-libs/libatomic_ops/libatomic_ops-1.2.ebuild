# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libatomic_ops/libatomic_ops-1.2.ebuild,v 1.6 2007/06/08 23:15:28 lu_zero Exp $

inherit eutils

DESCRIPTION="Implementation for atomic memory update operations"
HOMEPAGE="http://www.hpl.hp.com/research/linux/atomic_ops/"
SRC_URI="http://www.hpl.hp.com/research/linux/atomic_ops/download/${P}.tar.gz"

LICENSE="GPL-2 MIT as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""
src_unpack(){
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${P}-ppc64-load_acquire.patch"
}
src_install() {
	emake pkgdatadir="/usr/share/doc/${PF}" DESTDIR="${D}" install
}
