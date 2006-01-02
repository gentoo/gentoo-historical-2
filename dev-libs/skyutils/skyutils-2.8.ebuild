# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/skyutils/skyutils-2.8.ebuild,v 1.2 2006/01/02 12:24:15 mrness Exp $

IUSE="ssl"

DESCRIPTION="Library of assorted C utility functions."
HOMEPAGE="http://zekiller.skytech.org/coders_en.html"
SRC_URI="http://zekiller.skytech.org/fichiers/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND="virtual/libc
	sys-apps/gawk
	sys-devel/gcc
	ssl? ( dev-libs/openssl )"

RDEPEND="virtual/libc"

src_compile() {
	econf `use_enable ssl` || die "./configure failed"
	emake || die "make failed"
}

src_install () {
	emake DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
