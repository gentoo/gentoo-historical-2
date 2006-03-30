# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/expat/expat-2.0.0.ebuild,v 1.3 2006/03/30 15:03:11 flameeyes Exp $

inherit libtool multilib

DESCRIPTION="XML parsing libraries"
HOMEPAGE="http://expat.sourceforge.net/"
SRC_URI="mirror://sourceforge/expat/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="test"

DEPEND="test? ( >=dev-libs/check-0.8 )"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	elibtoolize
}

src_test() {
	if ! use test && [[ -z $(best_version dev-libs/check) ]] ; then
		ewarn "You dont have USE=test and dev-libs/check is not installed."
		ewarn "src_test will be skipped."
		return 0
	fi
	make check || die "make check failed"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc Changes README
	dohtml doc/*
}

pkg_postinst() {
	ewarn "Please note that the soname of the library changed!"
	ewarn "If you are upgrading from a previous version you need"
	ewarn "to fix dynamic linking inconsistencies by executing:"
	ewarn "revdep-rebuild --library libexpat.so.0"
}
