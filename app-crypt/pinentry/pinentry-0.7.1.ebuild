# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/pinentry/pinentry-0.7.1.ebuild,v 1.2 2004/05/20 10:47:11 pauldv Exp $

DESCRIPTION="collection of simple PIN or passphrase entry dialogs which utilize the Assuan protocol"
HOMEPAGE="http://www.gnupg.org/aegypten/"
SRC_URI="ftp://ftp.gnupg.org/gcrypt/pinentry/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="qt gtk ncurses"

DEPEND="gtk? ( x11-libs/gtk+ )
	ncurses? ( sys-libs/ncurses )
	qt? ( x11-libs/qt )
	!gtk? ( !qt? ( !ncurses? ( sys-libs/ncurses ) ) )"

src_compile() {
	local myconf=""
	if ! use qt && ! use gtk && ! use ncurses ; then
		myconf="--enable-pinentry-curses --enable-fallback-curses"
	fi
	econf \
		`use_enable qt pinentry-qt` \
		`use_enable gtk pinentry-gtk` \
		`use_enable ncurses pinentry-curses` \
		`use_enable ncurses fallback-curses` \
		--disable-dependency-tracking \
		${myconf} \
		|| die
	make || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	# The other two pinentries don't spit out an insecure memory warning when
	# not suid root, and gtk refuses to start if pinentry-gtk is suid root.
	fperms +s /usr/bin/pinentry-qt
}

pkg_postinst() {
	einfo "pinentry-qt is installed SUID root to make use of protected memory space"
	einfo "This is needed in order to have a secure place to store your passphrases,"
	einfo "etc. at runtime but may make some sysadmins nervous"
}
