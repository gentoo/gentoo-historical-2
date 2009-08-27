# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/zziplib/zziplib-0.13.56.ebuild,v 1.2 2009/08/27 10:38:48 alexxy Exp $

EAPI="2"
inherit libtool eutils flag-o-matic

DESCRIPTION="Lightweight library used to easily extract data from files archived in a single zip file"
HOMEPAGE="http://zziplib.sourceforge.net/"
SRC_URI="mirror://sourceforge/zziplib/${P}.tar.bz2"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="sdl test"

RDEPEND=">=dev-lang/python-2.4
	sys-libs/zlib
	sdl? ( >=media-libs/libsdl-1.2.6 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	test? ( app-arch/zip )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.13.49-SDL-test.patch
	# zziplib tries to install backwards compat symlinks we dont want
	sed -i -e '/^zzip-postinstall:/s|$|\ndisable-this:|' Makefile.in || die
	sed -i -e '/^install-exec-local:/s|$|\ndisable-this:|' zzip/Makefile.in || die
	elibtoolize
}

src_configure() {
	append-flags -fno-strict-aliasing # bug reported upstream
	econf $(use_enable sdl)
}

src_test() {
	# need this because `make test` will always return true
	# tests fail with -j > 1 (bug #241186)
	emake -j1 check || die "make check failed"
}

src_install() {
	emake DESTDIR="${D}" install install-man3 || die "make install failed"
	dodoc ChangeLog README TODO
	dohtml docs/*
}
