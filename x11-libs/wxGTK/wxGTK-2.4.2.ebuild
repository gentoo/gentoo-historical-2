# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/wxGTK/wxGTK-2.4.2.ebuild,v 1.1 2003/10/07 23:49:33 liquidx Exp $

DESCRIPTION="GTK+ version of wxWindows, a cross-platform C++ GUI toolkit."
SRC_URI="mirror://sourceforge/wxwindows/${P}.tar.bz2"
HOMEPAGE="http://www.wxwindows.org/"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc"
IUSE="nls odbc opengl gtk2 unicode debug"

RDEPEND="virtual/x11
	sys-libs/zlib
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	odbc? ( dev-db/unixODBC  )
	opengl? ( virtual/opengl )
	gtk2? ( >=x11-libs/gtk+-2.0 >=dev-libs/glib-2.0 )
	!gtk2? ( =x11-libs/gtk+-1.2* =dev-libs/glib-1.2* )"

DEPEND="${RDEPEND}
	gtk2? ( dev-util/pkgconfig )"

# Note 1: Gettext is not runtime dependency even if nls? because wxWindows
#         has its own implementation of it
# Note 2: We disable unicode support because otherwise it breaks with
#         some poorly implemented wxWindows apps like xmule and lmule.
# Note 3: PCX support is enabled if the correct libraries are detected.
#         There is no USE flag for this.

src_unpack() {
	unpack ${A}
	# fix xml contrib makefile problems
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/${PN}-2.4.1-contrib.patch
	# disable contrib/src/animate
	EPATCH_OPTS="-d ${S}/contrib/src" epatch ${FILESDIR}/${PN}-2.4.2-contrib_animate.patch
}

src_compile() {
	local myconf

	myconf="${myconf} `use_with odbc`"
	myconf="${myconf} `use_with opengl`"
	myconf="${myconf} --with-gtk"
	myconf="${myconf} `use_enable debug`"

	# here we disable unicode support even thought gtk2 supports it
	# because too many apps just don't follow the wxWindows guidelines
	# for unicode support.
	#
	# http://www.wxwindows.org/manuals/2.4.0/wx458.htm#unicode
	#
	# bug #20116 - liquidx@gentoo.org (07 May 2003)

	#use gtk2 && myconf="${myconf} --enable-gtk2 --enable-unicode"
	use gtk2 && myconf="${myconf} --enable-gtk2"
	use gtk2 && use unicode && myconf="${myconf} --enable-unicode"

	econf ${myconf}
	emake || die "make failed"

	cd ${S}/contrib/src
	emake || die "make contrib failed"
}

src_install() {
	einstall || die "install failed"
	dodoc *.txt

	cd ${S}/contrib/src
	einstall || die "install contrib failed"
}
