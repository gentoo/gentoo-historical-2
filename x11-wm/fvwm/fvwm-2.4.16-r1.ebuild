# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/fvwm/fvwm-2.4.16-r1.ebuild,v 1.3 2003/09/05 00:56:25 msterret Exp $

inherit gnuconfig

IUSE="readline ncurses gtk stroke gnome rplay xinerama cjk imlib"

S=${WORKDIR}/${P}
DESCRIPTION="an extremely powerful ICCCM-compliant multiple virtual desktop window manager"
SRC_URI="ftp://ftp.fvwm.org/pub/fvwm/version-2/${P}.tar.bz2"
HOMEPAGE="http://www.fvwm.org/"

SLOT="0"
KEYWORDS="x86 alpha"
LICENSE="GPL-2 FVWM"

RDEPEND="readline? ( >=sys-libs/readline-4.1
				ncurses? ( >=sys-libs/ncurses-5.3-r1 )
				!ncurses? ( >=sys-libs/libtermcap-compat-1.2.3 ) )
		gtk? ( =x11-libs/gtk+-1.2*
				imlib? ( >=media-libs/gdk-pixbuf-0.21.0
						>=media-libs/imlib-1.9.14-r1 ) )
		gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )
		rplay? ( >=media-sound/rplay-3.3.2 )
		stroke? ( >=dev-libs/libstroke-0.4 )
		>=dev-lang/perl-5.8.0
		virtual/x11"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	use alpha && gnuconfig_update

	# CFLAGS containing comma will break this, so change it for !
	sed -i 's#\x27s,xCFLAGSx,$(CFLAGS),\x27#\x27s!xCFLAGSx!$(CFLAGS)!\x27#' ${S}/utils/Makefile.am
}

src_compile() {
	local myconf="--libexecdir=/usr/lib"

	# use readline in FvwmConsole.
	if ! use readline; then
		myconf="${myconf} --without-readline-library"
	else
		myconf="${myconf} --with-readline-library"

		# choose ncurses or termcap.
		if use ncurses; then
			myconf="${myconf} --without-termcap-library"
		else
			myconf="${myconf} --without-ncurses-library"
		fi
	fi

	# fvwm configure doesnt provide a way to disable gtk support if the
	# required libraries are found, this hides them from the script.
	if ! use gtk; then
		myconf="${myconf} --with-gtk-prefix=${T} --with-imlib-prefix=${T}"
	else
		if ! use imlib; then
			myconf="${myconf} --with-imlib-prefix=${T}"
		fi
	fi

	# link with the gnome libraries, for better integration with the gnome desktop.
	if use gnome; then
		myconf="${myconf} --with-gnome"
	else
		myconf="${myconf} --without-gnome"
	fi

	# rplay is a cool, but little used way of playing sounds over a network
	# Fvwm support is pretty good.
	if ! use rplay; then
		myconf="${myconf} --without-rplay-library"
	fi

	# xinerama support for those who have multi-headed machines.
	if use xinerama; then
		myconf="${myconf} --enable-xinerama"
	else
		myconf="${myconf} --disable-xinerama"
	fi

	# multibyte character support, chinese/japanese/korean/etc.
	if use cjk; then
		myconf="${myconf} --enable-multibyte"
	else
		myconf="${myconf} --disable-multibyte"
	fi

	# support for mouse gestures using libstroke (very very cool)
	if ! use stroke; then
		myconf="${myconf} --without-stroke-library"
	fi

	# must specify PKG_CONFIG or Xft detection bombs.
	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	echo "#!/bin/bash" > fvwm2
	echo "exec /usr/bin/fvwm2" >> fvwm2

	exeinto /etc/X11/Sessions
	doexe fvwm2

	dodoc AUTHORS ChangeLog COPYING README NEWS docs/ANNOUNCE docs/BUGS \
	docs/DEVELOPERS docs/FAQ docs/error_codes docs/color_combos docs/TODO \
	docs/fvwm.lsm
}

pkg_postinst() {
	ewarn
	ewarn "The following features that you did not request are now"
	ewarn "controlled via USE flags:"
	use readline	|| ewarn "	Readline support in FvwmConsole [readline]"
	use ncurses		|| ewarn "	Ncurses support in FvwmConsole [ncurses]"
	use stroke		|| ewarn "	Mouse Gestures [stroke]"
	use xinerama	|| ewarn "	Xinerama Support [xinerama]"
	use cjk			|| ewarn "	Multibyte Character Support [cjk]"
	use rplay		|| ewarn "	RPlay Support in FvwmEvent [rplay]"
	use gtk			|| ewarn "	FvwmGTK (gtk+ support) [gtk]"
	use imlib		|| ewarn "	FvwmGTK (GDK image support) [imlib]"
	ewarn
	ewarn "If you require any of the features listed above, you should remerge"
	ewarn "FVWM with the appropriate USE flags. Use this command to see the flags"
	ewarn "available:"
	ewarn "	$ emerge -pv fvwm"
	ewarn
}
