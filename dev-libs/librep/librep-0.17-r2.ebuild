# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/librep/librep-0.17-r2.ebuild,v 1.8 2006/09/17 08:45:28 nixnut Exp $

inherit eutils libtool toolchain-funcs multilib

DESCRIPTION="Shared library implementing a Lisp dialect"
HOMEPAGE="http://librep.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ia64 ppc sparc ~x86"
IUSE="readline"

RDEPEND=">=sys-libs/gdbm-1.8.0
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}
	sys-apps/texinfo"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/libtool.patch"
	epatch "${FILESDIR}/rep_file_fdopen.patch"
	sed -i -e '7s/AM_PATH_REP/[&]/' rep.m4 || die "sed failed"
	elibtoolize || die "elibtoolize failed"
	epunt_cxx
}

src_compile() {
	local myconf="$(use_with readline)"
	use ppc && myconf="${myconf} --with-stack-direction=1"

	# It seems that stack-direction=-1 for gcc-3.x and 1 for gcc-4.x on ia64
	if use ia64 && [[ $(gcc-major-version) -ge 4 ]]; then
		myconf="${myconf} --with-stack-direction=1"
	fi

	econf \
		--libexecdir=/usr/$(get_libdir) \
		--without-gmp \
		--without-ffi \
		${myconf} || die "configure failed"

	LC_ALL=C emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README THANKS TODO TREE
	docinto doc
	dodoc doc/*
}
