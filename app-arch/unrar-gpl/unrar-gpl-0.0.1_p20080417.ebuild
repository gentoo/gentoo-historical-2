# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unrar-gpl/unrar-gpl-0.0.1_p20080417.ebuild,v 1.3 2009/01/29 16:38:51 hanno Exp $

inherit autotools

DESCRIPTION="Free rar unpacker"
HOMEPAGE="http://home.gna.org/unrar/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND="!app-arch/unrar"
S="${WORKDIR}/${PN/-gpl}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf || die "eautoreconf failed"
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README || die "dodoc failed"
}
