# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/zziplib/zziplib-0.10.82.ebuild,v 1.3 2004/06/24 23:39:23 agriffis Exp $

inherit fixheadtails

DESCRIPTION="Lightweight library used to easily extract data from files archived in a single zip file"
HOMEPAGE="http://zziplib.sourceforge.net/"
SRC_URI="mirror://sourceforge/zziplib/${P}.tar.bz2"

KEYWORDS="x86"
LICENSE="LGPL-2.1 | MPL-1.1"
SLOT="0"
IUSE="sdl"

DEPEND="sys-libs/zlib
	sdl? ( >=media-libs/libsdl-1.2.5 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	ht_fix_all
}

src_compile() {
	econf \
		--disable-dependency-tracking \
		`use_enable sdl` || die
	emake                || die "emake failed"
}

src_install() {
	einstall                                        || die
	dodoc ChangeLog README TODO docs/staticlink.txt || die "dodoc failed"
	dohtml docs/*                                   || die "dohtml failed"
}
