# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/mp/mp-3.3.14-r1.ebuild,v 1.1 2005/11/19 19:58:04 compnerd Exp $

inherit eutils

DESCRIPTION="Minimum Profit: A text editor for programmers"
HOMEPAGE="http://www.triptico.com/software/mp.html"
SRC_URI="http://www.triptico.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE="gtk ncurses nls pcre"

DEPEND="virtual/libc
		ncurses? ( sys-libs/ncurses )
		gtk? ( >=x11-libs/gtk+-2 >=x11-libs/pango-1.8.0 )
		!gtk? ( sys-libs/ncurses )
		nls? ( sys-devel/gettext )
		pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}
		 dev-lang/perl"

src_compile() {
	local myconf="--without-win32 --without-gtk1"

	if use gtk ; then
		! use ncurses && myconf="${myconf} --without-curses"
	else
		myconf="${myconf} --without-gtk2"
	fi

	use nls || myconfig="${myconf} --without-i18n --without-gettext"
	use pcre || myconf="${myconf} --without-pcre --with-included-regex"

	sh config.sh ${myconf} || die "Configure failed"

	echo ${CFLAGS} >> config.cflags
	echo ${LDFLAGS} >> config.ldflags

	emake || die "Compile Failed"
}

src_install() {
	dobin mp || die "Install Failed"

	use gtk && dosym mp ${DESTTREE}/bin/gmp

	dodoc AUTHORS README Changelog mprc.sample
	doman mp.1
}

pkg_postinst() {
	if use gtk ; then
		einfo
		einfo "mp is symlinked to gmp! Use mp -tx to use text mode!"
		einfo
		epause 5
	fi
}
