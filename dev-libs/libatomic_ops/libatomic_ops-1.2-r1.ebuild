# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libatomic_ops/libatomic_ops-1.2-r1.ebuild,v 1.9 2010/01/15 18:09:38 grobian Exp $

inherit eutils

DESCRIPTION="Implementation for atomic memory update operations"
HOMEPAGE="http://www.hpl.hp.com/research/linux/atomic_ops/"
SRC_URI="http://www.hpl.hp.com/research/linux/atomic_ops/download/${P}.tar.gz"

LICENSE="GPL-2 MIT as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86 ~x86-fbsd ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-ppc64-load_acquire.patch
	epatch "${FILESDIR}"/${P}-ppc-asm.patch
}

src_install() {
	emake pkgdatadir="${EPREFIX}/usr/share/doc/${PF}" DESTDIR="${D}" install || die
}
