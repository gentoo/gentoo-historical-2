# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/c-ares/c-ares-1.5.3.ebuild,v 1.3 2009/01/23 21:42:56 maekke Exp $

DESCRIPTION="C library that resolves names asynchronously"
HOMEPAGE="http://daniel.haxx.se/projects/c-ares/"
SRC_URI="http://daniel.haxx.se/projects/c-ares/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""

src_compile() {
	econf --enable-shared || die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc CHANGES NEWS README*
}

pkg_postinst() {
	ewarn "The soname for libares has changed in c-ares-1.4.0."
	#ewarn "If you have upgraded from that or earlier version, it is recommended to run:"
	ewarn
	ewarn "revdep-rebuild --library libcares.so.1"
	ewarn
	ewarn "This will fix linking errors caused by this change."
	echo
}
