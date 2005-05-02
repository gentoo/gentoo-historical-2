# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/wxGTK/wxGTK-2.5.3.ebuild,v 1.7 2005/05/02 17:57:03 pythonhead Exp $

inherit eutils gnuconfig multilib toolchain-funcs

DESCRIPTION="GTK+ version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="http://www.wxwidgets.org/"
SRC_URI="mirror://sourceforge/wxwindows/${P}.tar.bz2"

LICENSE="wxWinLL-3"
SLOT="2.5"
KEYWORDS="~x86"
IUSE="debug no_wxgtk1 gtk2 odbc opengl unicode"

RDEPEND="virtual/x11
	sys-libs/zlib
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	!unicode? ( odbc? ( dev-db/unixODBC ) )
	opengl? ( virtual/opengl )
	gtk2? ( >=x11-libs/gtk+-2.0 >=dev-libs/glib-2.0 )
	!no_wxgtk1? ( =x11-libs/gtk+-1.2* =dev-libs/glib-1.2* )"
DEPEND="${RDEPEND}
	gtk2? ( dev-util/pkgconfig )
	sys-apps/sed"

# Note 1: Gettext is not runtime dependency even if nls? because wxWidgets
#         has its own implementation of it
# Note 2: PCX support is enabled if the correct libraries are detected.
#         There is no USE flag for this.

pkg_setup() {
	einfo "New in >=wxGTK-2.4.2-r2:"
	einfo "------------------------"
	einfo "You can now have gtk, gtk2(ansi) and gtk2(unicode) versions installed"
	einfo "simultaneously. gtk is installed by default because it is"
	einfo "more stable than gtk2. Use no_wxgtk1 if you don't want it."
	einfo "Put gtk2 and unicode in your USE flags to get those"
	einfo "additional versions if desired."
	einfo "NOTE:"
	einfo "You can also get debug versions of any of those, but not debug"
	einfo "and normal installed at the same time."
	if  use unicode; then
		! use gtk2 && die "You must put gtk2 in your USE if you need unicode support"
	fi
	if use no_wxgtk1 && ! use gtk2; then
		die "You must have at least gtk2 or -no_wxgtk1 in your USE"
	fi
}

src_compile() {
	gnuconfig_update

	local myconf
	export LANG='C'
	sed -i "s/-O2//g" configure || die "sed configure failed"

	myconf="${myconf} `use_with opengl`"
	myconf="${myconf} --with-gtk"
	myconf="${myconf} `use_enable debug`"
	myconf="${myconf} --libdir=/usr/$(get_libdir)"

	if ! use no_wxgtk1 ; then
		mkdir build_gtk
		einfo "Building gtk version"
		cd build_gtk
		../configure ${myconf} --disable-gtk2 `use_with odbc`\
			--host=${CHOST} \
			--prefix=/usr \
			--infodir=/usr/share/info \
			--mandir=/usr/share/man || die "./configure failed"
		emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" || die "make gtk failed"
		cd contrib/src
		emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" || die "make gtk contrib failed"
	fi
	cd ${S}

	if use gtk2 ; then
		myconf="${myconf} --enable-gtk2"
		einfo "Building gtk2 version"
		mkdir build_gtk2
		cd build_gtk2
		../configure ${myconf} \
			--host=${CHOST} \
			--prefix=/usr \
			--infodir=/usr/share/info \
			--mandir=/usr/share/man || die "./configure failed"
		emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" || die "make gtk2 failed"
		cd contrib/src
		emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" || die "make gtk2 contrib failed"

		cd ${S}

		if use unicode ; then
			myconf="${myconf} --enable-unicode"
			einfo "Building unicode version"
			mkdir build_unicode
			cd build_unicode
			../configure ${myconf} \
				--host=${CHOST} \
				--prefix=/usr \
				--infodir=/usr/share/info \
				--mandir=/usr/share/man || die "./configure failed"

			emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" || die "make unicode failed"

			cd contrib/src
			emake CXX="$(tc-getCXX)" CC="$(tc-getCC)" || die "make unicode contrib failed"
		fi
	fi
}

src_install() {
	if [ -e ${S}/build_gtk ] ; then
		cd ${S}/build_gtk
		einstall libdir="${D}/usr/$(get_libdir)" || die "install gtk failed"
		cd contrib/src
		einstall libdir="${D}/usr/$(get_libdir)" || die "install gtk contrib failed"
	fi

	if [ -e ${S}/build_unicode ] ; then
		cd ${S}/build_unicode
		einstall libdir="${D}/usr/$(get_libdir)" || die "install unicode failed"
		cd contrib/src
		einstall libdir="${D}/usr/$(get_libdir)" || die "install unicode contrib failed"
	fi

	if [ -e ${S}/build_gtk2 ] ; then
		cd ${S}/build_gtk2
		einstall libdir="${D}/usr/$(get_libdir)" || die "install gtk2 failed"
		cd contrib/src
		einstall libdir="${D}/usr/$(get_libdir)" || die "install gtk2 contrib failed"
	fi

	# /usr/bin/wx-config is a symlink to the real wx-config. 2.4 and 2.5 
	# don't have compatible versions. (See wxwidgets.eclass)
	# Since 2.5.3 is un-tested and breaks most apps, we'll remove wx-config
	# and force people to use the wxwidgets eclass and export WX_GTK_VER=2.5 
	# to find it:
	rm ${D}/usr/bin/wx-config

	dodoc ${S}/*.txt

	# twp 20040830 wxGTK forgets to install htmlproc.h; copy it manually
	# Not sure if this will be necessary for 2.5, verify: pythonhead 10 Nov 2004
	# This was for wxRuby
	#insinto /usr/include/wx/html
	#doins ${S}/include/wx/html/htmlproc.h
}
