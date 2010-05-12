# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pacman/pacman-3.3.3.ebuild,v 1.1 2010/05/12 21:04:37 hwoarang Exp $

EAPI=2

inherit autotools

DESCRIPTION="Archlinux's binary package manager"
HOMEPAGE="http://archlinux.org/pacman/"
SRC_URI="ftp://ftp.archlinux.org/other/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug doc test"

COMMON_DEPEND="app-arch/libarchive
	virtual/libiconv
	virtual/libintl
	sys-devel/gettext"
RDEPEND="${COMMON_DEPEND}
	app-arch/xz-utils"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-lang/python )"

src_prepare() {
	sed -i -e '/-Werror/d' configure.ac || die "-Werror"
	# acinclude.m4 overrides libtool macros from /usr/share/aclocal, causing
	# elibtoolize's ltmain.sh to incompatible with ./configure after
	# eautoreconf is run.
	sed -i -e '4,/dnl Add some custom macros for pacman and libalpm/d' acinclude.m4 || die "libtool fix"
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		--disable-git-version \
		--disable-internal-download \
		$(use_enable debug) \
		$(use_enable doc) \
		$(use_enable doc doxygen)
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodir /etc/pacman.d || die
}

pkg_postinst() {
	einfo "Please see http://ohnopub.net/~ohnobinki/gentoo/arch/ for information"
	einfo "about setting up an archlinux chroot."
}
