# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/dynamite/dynamite-0.1.ebuild,v 1.5 2004/06/26 22:37:50 liquidx Exp $

inherit eutils

DESCRIPTION="Dynamite is a tool and library for decompressing data compressed with PKWARE Data Compression Library"
HOMEPAGE="http://sourceforge.net/projects/synce/"
SRC_URI="mirror://sourceforge/synce/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}; epatch ${FILESDIR}/${P}-segv.patch

}
src_compile() {
	econf || die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README
}
