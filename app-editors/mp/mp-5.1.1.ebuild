# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/mp/mp-5.1.1.ebuild,v 1.9 2011/03/27 10:20:03 nirbheek Exp $

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="Minimum Profit: A text editor for programmers"
HOMEPAGE="http://www.triptico.com/software/mp.html"
SRC_URI="http://www.triptico.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-interix ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="gtk ncurses nls pcre iconv"

RDEPEND="
	ncurses? ( sys-libs/ncurses )
	gtk? ( x11-libs/gtk+:2 >=x11-libs/pango-1.8.0 )
	!gtk? ( sys-libs/ncurses )
	nls? ( sys-devel/gettext )
	pcre? ( dev-libs/libpcre )
	iconv? ( virtual/libiconv )
	app-text/grutatxt"
DEPEND="${RDEPEND}
	app-text/grutatxt
	dev-util/pkgconfig
	dev-lang/perl"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-prll.patch
}

src_configure() {
	local myconf="--prefix=${EPREFIX}/usr --without-win32"

	if use gtk; then
		! use ncurses && myconf="${myconf} --without-curses"
	else
		myconf="${myconf} --without-gtk2"
	fi

	use nls || myconfig="${myconf} --without-gettext"

	myconf="${myconf} $(use_with pcre)"
	use pcre || myconf="${myconf} --with-included-regex"

	use iconv || myconf="${myconf} --without-iconv"

	for i in "${S}" "${S}"/mpsl "${S}"/mpdm;do
		echo ${CFLAGS} >> $i/config.cflags
		echo ${LDFLAGS} >> $i/config.ldflags
	done

	tc-export CC
	sh config.sh ${myconf} || die "Configure failed"
}

src_install() {
	dodir /usr/bin
	sh config.sh --prefix="${EPREFIX}/usr"
	emake DESTDIR="${D}" install || die "Install Failed"
	use gtk && dosym mp-5 /usr/bin/gmp
}

pkg_postinst() {
	if use gtk ; then
		einfo
		einfo "mp-5 is symlinked to gmp! Use"
		einfo "$ DISPLAY=\"\" mp-5"
		einfo "to use text mode!"
		einfo
	fi
}
