# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/fvwm/fvwm-2.5.7-r1.ebuild,v 1.4 2003/08/14 12:01:26 taviso Exp $

inherit gnuconfig

IUSE="readline ncurses gtk stroke gnome rplay xinerama cjk perl nls png bidi imlib tcltk debug"

S=${WORKDIR}/${P}
DESCRIPTION="An extremely powerful ICCCM-compliant multiple virtual desktop window manager"
SRC_URI="ftp://ftp.fvwm.org/pub/fvwm/version-2/${P}.tar.bz2
		perl? ( http://users.tpg.com.au/users/scottie7/FvwmTabs 
				http://users.tpg.com.au/users/scottie7/fvwmtabrc )"
HOMEPAGE="http://www.fvwm.org/"

SLOT="0"
KEYWORDS="~x86 ~alpha ~sparc"
LICENSE="GPL-2 FVWM"

RDEPEND="readline? ( >=sys-libs/readline-4.1 
				ncurses? ( >=sys-libs/ncurses-5.3-r1 )
				!ncurses? ( >=sys-libs/libtermcap-compat-1.2.3 ) )
		gtk? ( =x11-libs/gtk+-1.2* 
				imlib? ( >=media-libs/gdk-pixbuf-0.21.0 
						>=media-libs/imlib-1.9.14-r1 ) )
		gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )
		rplay? ( >=media-sound/rplay-3.3.2 )
		bidi? ( >=dev-libs/fribidi-0.10.4 )
		png? ( >=media-libs/libpng-1.0.12-r2 )
		stroke? ( >=dev-libs/libstroke-0.4 )
		perl? ( tcltk? ( >=dev-lang/tk-8.3.4
						>=dev-perl/perl-tk-800.024-r2
						>=dev-perl/X11-Protocol-0.51 ) )
		>=dev-lang/perl-5.6.1-r10	
		>=media-libs/netpbm-9.12-r4
		>=media-libs/fontconfig-2.1-r1
		>=dev-libs/expat-1.95.6-r1
		virtual/x11
		virtual/xft"
DEPEND="${RDEPEND} 
	>=sys-apps/sed-4
	sys-devel/automake
	sys-devel/autoconf
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	
	use alpha && gnuconfig_update
	
	# CFLAGS containing comma will break this, so change it for !
	sed -i 's#\x27s,xCFLAGSx,$(CFLAGS),\x27#\x27s!xCFLAGSx!$(CFLAGS)!\x27#' ${S}/utils/Makefile.am

	# Xft detection is totally b0rked if using pkg-config, this update from cvs.	
	cp ${FILESDIR}/acinclude.m4 ${S}/acinclude.m4
}

src_compile() {
	local myconf="--libexecdir=/usr/lib --enable-xft"

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

	# Install perl bindings for FvwmPerl.
	if use perl; then 
		myconf="${myconf} --enable-perllib" 
	else
		myconf="${myconf} --disable-perllib"
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

	# bidirectional writing support, eg hebrew
	if use bidi; then
		myconf="${myconf} --enable-bidi"
	else
		myconf="${myconf} --disable-bidi"
	fi

	# png image support (very nice in fvwm)
	if ! use png; then
		myconf="${myconf} --without-png-library"
	fi
	
	# native language support
	if use nls; then
		myconf="${myconf} --enable-nls"
	else
		myconf="${myconf} --disable-nls"
	fi

	# support for mouse gestures using libstroke (very very cool)
	if ! use stroke; then
		myconf="${myconf} --without-stroke-library"
	fi
	
	# more verbosity for module developers/hackers/etc.
	if use debug; then
		myconf="${myconf} --enable-debug-msgs --enable-command-log"
	fi
	
	# Xft detection is broken in this release, the fix is in cvs
	# which ive installed here, rerun automake to sort the problem.
	einfo "Fixing Xft detection, please wait..."
 	(	einfo "	Running aclocal..."
		aclocal
		einfo "	Running autoheader..."
		autoheader
		einfo "	Running automake..."
		automake --add-missing
		einfo "	Running autoreconf..."
		autoreconf ) 2>/dev/null
	einfo "Fixed."
	
	# must specify PKG_CONFIG or Xft detection bombs.
	econf ${myconf} PKG_CONFIG=/usr/bin/pkg-config || die
	emake || die
}

src_install() {

	make DESTDIR=${D} install || die

	if use perl; then 
		
		local toolkits="gtk2 gtk tcltk"
		
		if use tcltk; then
			# Install the very cool FvwmTabs module
			# http://users.tpg.com.au/users/scottie7/FvwmTabs
			einfo "Installing FvwmTabs module..."
			exeinto /usr/lib/fvwm/${PV}/
			doexe ${DISTDIR}/FvwmTabs
			dodoc ${DISTDIR}/fvwmtabrc
		else
			# Remove the Tk bindings (requires perl-tk)
			rm -f ${D}/usr/share/fvwm/perllib/FVWM/Module/Tk.pm
			toolkits=${toolkits/tcltk/}
		fi
		if ! use gtk2; then
			# Remove the gtk2 bindings (requires gtk2-perl)
			rm -f ${D}/usr/share/fvwm/perllib/FVWM/Module/Gtk2.pm
			toolkits=${toolkits/gtk2/}
		fi
		if ! use gtk; then
			# Remove gtk1 bindings (requires gtk-perl)
			rm -f ${D}/usr/share/fvwm/perllib/FVWM/Module/Gtk.pm
			toolkits=${toolkits/gtk/}
		fi
		toolkits=${toolkits// /}
		if ! test "${toolkits}"; then
			# No perl toolkit bindings wanted, remove the unneeded files
			# and empty directories.
			rm -f ${D}/usr/share/fvwm/perllib/FVWM/Module/Toolkit.pm
			find ${D}/usr/share/fvwm/perllib -depth -type d -exec rmdir {} \; 2>/dev/null
		fi
	else
		# Remove useless script if perllib isnt required.
		rm -rf ${D}/usr/bin/fvwm-perllib ${D}/usr/share/man/man1/fvwm-perllib.1
	fi
	
	# ive included `exec` to save a few bytes of memory.
	echo "#!/bin/bash" > fvwm2
	echo "exec /usr/bin/fvwm2" >> fvwm2

	exeinto /etc/X11/Sessions
	doexe fvwm2

	dodoc AUTHORS ChangeLog COPYING README NEWS docs/ANNOUNCE docs/BUGS \
	docs/COMMANDS docs/DEVELOPERS docs/FAQ docs/error_codes docs/TODO \
	docs/fvwm.lsm

	prepallman
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
	use perl 		|| ewarn "	FVWM Perl bindings [perl]"
	use tcltk		|| ewarn "	FVWM Perl-tk support, including FvwmTabs [perl tcltk]"
	use nls			|| ewarn "	Native Language Support [nls]"
	use png			|| ewarn "	PNG Support [png]"
	use bidi		|| ewarn "	Bidirectional Language Support [bidi]"
	use rplay		|| ewarn "	RPlay Support in FvwmEvent [rplay]"
	use gtk			|| ewarn "	FvwmGTK (gtk+ support) [gtk]"
	use imlib		|| ewarn "	FvwmGTK (GDK image support) [imlib]"
	ewarn
	ewarn "If you require any of the features listed above, you should remerge"
	ewarn "FVWM with the appropriate USE flags. Use this command to see the flags"
	ewarn "available:"
	ewarn "	$ emerge -pv fvwm"
	ewarn
	use perl && use tcltk && {
		einfo "The FvwmTabs module has been installed (USE=\"perl tcltk\")."
		einfo "For more information, visit"
		einfo "http://users.tpg.com.au/users/scottie7/fvwmtabs.html"
		einfo
		einfo "The fvwmtabrc has been installed into /usr/share/doc/${PF}"
	}
}
