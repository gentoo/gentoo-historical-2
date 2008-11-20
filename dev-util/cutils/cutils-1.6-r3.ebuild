# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cutils/cutils-1.6-r3.ebuild,v 1.1 2008/11/20 02:49:27 tcunha Exp $

inherit eutils toolchain-funcs

DESCRIPTION="C language utilities"
HOMEPAGE="http://www.sigala.it/sandro/software.php#cutils"
SRC_URI="http://www.sigala.it/sandro/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-r1-gentoo.diff
	cd "${S}"/src/cdecl
	mv cdecl.1 cutils-cdecl.1
	for file in "${S}"/doc/*; do
		sed -e 's/cdecl/cutils-cdecl/g' -i "${file}"
	done
	sed -e 's/Xr cdecl/Xr cutils-cdecl/' -i "${S}"/src/cundecl/cundecl.1
}

src_compile() {
	econf
	emake CC="$(tc-getCC)" -j1 || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CREDITS HISTORY NEWS README || die "dodoc failed"
}

pkg_postinst () {
	elog "cdecl was installed as cutils-cdecl because of a naming conflict"
	elog "with dev-util/cdecl."
}
