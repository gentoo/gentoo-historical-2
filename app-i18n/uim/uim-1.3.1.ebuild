# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/uim/uim-1.3.1.ebuild,v 1.1 2006/12/22 17:24:36 matsuu Exp $

inherit eutils kde-functions flag-o-matic multilib elisp-common

DESCRIPTION="Simple, secure and flexible input method library"
HOMEPAGE="http://uim.freedesktop.org/"
SRC_URI="http://uim.freedesktop.org/releases/${P}.tar.gz"

LICENSE="BSD GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="anthy canna eb emacs gnome gtk kde libedit m17n-lib ncurses nls prime qt3 X"

RDEPEND="X? ( || ( (
			x11-libs/libX11
			x11-libs/libXft
			x11-libs/libXt
			x11-libs/libICE
			x11-libs/libSM
			x11-libs/libXext
			x11-libs/libXrender
		)
		<virtual/x11-7 ) )
	anthy? ( || ( app-i18n/anthy app-i18n/anthy-ss ) )
	canna? ( app-i18n/canna )
	eb? ( dev-libs/eb )
	emacs? ( virtual/emacs )
	gnome? ( >=gnome-base/gnome-panel-2.14 )
	gtk? ( >=x11-libs/gtk+-2.4 )
	kde? ( kde-base/kdelibs )
	libedit? ( dev-libs/libedit )
	m17n-lib? ( >=dev-libs/m17n-lib-1.3.1 )
	ncurses? ( sys-libs/ncurses )
	nls? ( virtual/libintl )
	prime? ( app-i18n/prime )
	qt3? ( $(qt_min_version 3.3.4) )
	!app-i18n/uim-svn
	!<app-i18n/prime-0.9.4"

DEPEND="${RDEPEND}
	X? ( || ( (
			x11-proto/xextproto
			x11-proto/xproto
		)
		<virtual/x11-7 ) )"

pkg_setup() {
	if use qt3 && ! built_with_use =x11-libs/qt-3* immqt-bc && ! built_with_use =x11-libs/qt-3* immqt; then
		eerror "To support qt3 in this package is required to have"
		eerror "=x11-libs/qt-3* compiled with immqt-bc(recommended) or immqt USE flag."
		die "Please reemerge =x11-libs/qt-3* with USE=\"immqt-bc\" or USE=\"immqt\"."

	fi
	# An arch specific config directory is used on multilib systems
	has_multilib_profile && GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
	GTK2_CONFDIR=${GTK2_CONFDIR:=/etc/gtk-2.0/}
}

src_compile() {
	local myconf

	if use gtk && (use anthy || use canna); then
		myconf="${myconf} --enable-dict"
	else
		myconf="${myconf} --disable-dict"
	fi

	if use qt3 ; then
		append-flags -DQT_THREAD_SUPPORT
	fi

	if use gtk || use qt3 ; then
		myconf="${myconf} --enable-pref"
	else
		myconf="${myconf} --disable-pref"
	fi

	econf $(use_with X x) \
		$(use_with anthy) \
		$(use_with canna) \
		$(use_with eb) \
		$(use_enable emacs) \
		$(use_enable gnome gnome-applet) \
		$(use_with gtk gtk2) \
		$(use_with libedit) \
		$(use_enable kde kde-applet) \
		$(use_with m17n-lib m17nlib) \
		$(use_enable ncurses fep) \
		$(use_enable nls) \
		$(use_with qt3 qt) \
		$(use_with qt3 qt-immodule) \
		${myconf} || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog* NEWS README RELNOTE
	use emacs && elisp-site-file-install "${FILESDIR}"/50uim-el-gentoo.el
}

pkg_postinst() {
	einfo
	einfo "To use uim-skk you should emerge app-i18n/skk-jisyo."
	einfo

	ewarn
	ewarn "New input method switcher has been introduced. You need to set"
	ewarn
	ewarn "% GTK_IM_MODULE=uim ; export GTK_IM_MODULE"
	ewarn "% QT_IM_MODULE=uim ; export QT_IM_MODULE"
	ewarn "% XMODIFIERS=@im=uim ; export XMODIFIERS"
	ewarn
	ewarn "If you would like to use uim-anthy as default input method, put"
	ewarn "(define default-im-name 'anthy)"
	ewarn "to your ~/.uim."
	ewarn
	ewarn "All input methods can be found by running uim-im-switcher-gtk"
	ewarn "or uim-im-switcher-qt."
	ewarn

	use gtk && gtk-query-immodules-2.0 > "${ROOT}"/${GTK2_CONFDIR}/gtk.immodules
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use gtk && gtk-query-immodules-2.0 > "${ROOT}"/${GTK2_CONFDIR}/gtk.immodules
	use emacs && elisp-site-regen
}
