# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/smssend/smssend-3.1.ebuild,v 1.2 2003/02/13 15:07:40 vapier Exp $

DESCRIPTION="Universal SMS sender."

HOMEPAGE="http://zekiller.skytech.org/smssend_menu_en.html"

SRC_URI="http://zekiller.skytech.org/fichiers/smssend/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86"

DEPEND=">=dev-libs/skyutils-2.1"

#RDEPEND=""

S="${WORKDIR}/smssend"

src_compile() {
	econf \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}

