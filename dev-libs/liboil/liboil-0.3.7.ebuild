# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liboil/liboil-0.3.7.ebuild,v 1.7 2007/07/02 14:57:38 peper Exp $

inherit eutils
DESCRIPTION="Liboil is a library of simple functions that are optimized for various CPUs."
HOMEPAGE="http://www.schleef.org/liboil/"
SRC_URI="http://www.schleef.org/${PN}/download/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0.3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh -sparc ~x86"
IUSE=""
#RESTRICT="strip"
DEPEND="=dev-libs/glib-2*"
#RDEPEND=""
#S=${WORKDIR}/${P}

src_compile() {
	cd ${S}/liboil/powerpc
	epatch ${FILESDIR}/${P}-convfix.diff
	cd ${S}
	econf || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die
}
