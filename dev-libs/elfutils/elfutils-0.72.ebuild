# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/elfutils/elfutils-0.72.ebuild,v 1.3 2003/01/07 18:34:32 cretin Exp $

IUSE=""

S="${WORKDIR}/${P}"
DESCRIPTION="Libraries and utilities to handle compiled objects.
This should be a drop in replacement for libelf."
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="http://www.redhat.com/"

LICENSE="OpenSoftware"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~alpha"

DEPEND="virtual/glibc
	>=sys-devel/gcc-3.2.1-r6
	!dev-libs/libelf"

src_compile() {
	econf --program-prefix="eu-" \
		--enable-shared || die "./configure failed"
		
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog NEWS NOTES README THANKS TODO
}
