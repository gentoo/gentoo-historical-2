# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/graphviz/graphviz-2.28.0.ebuild,v 1.3 2012/05/28 21:35:21 sping Exp $

EAPI=3
PYTHON_DEPEND="python? 2"

inherit eutils autotools multilib python flag-o-matic

DESCRIPTION="Open Source Graph Visualization Software"
HOMEPAGE="http://www.graphviz.org/"
SRC_URI="http://www.graphviz.org/pub/graphviz/ARCHIVE/${P}.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
#original KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
KEYWORDS=""
IUSE="cairo devil doc examples gs gtk gts java lasi nls perl python qt4 ruby svg static-libs tcl elibc_FreeBSD"

# Requires ksh
RESTRICT="test"

RDEPEND="
	sys-libs/zlib
	>=dev-libs/expat-2
	>=dev-libs/glib-2.11.1
	>=media-libs/fontconfig-2.3.95
	>=media-libs/freetype-2.1.10
	>=media-libs/gd-2.0.34[fontconfig,jpeg,png,truetype]
	>=media-libs/libpng-1.2:0
	virtual/jpeg
	virtual/libiconv
	cairo?	(
		x11-libs/libXaw
		>=x11-libs/pango-1.12
		>=x11-libs/cairo-1.1.10[svg]
	)
	devil?	( media-libs/devil[png,jpeg] )
	gs?	( app-text/ghostscript-gpl )
	gtk?	(
		x11-libs/gtk+:2
		x11-libs/libXaw
		>=x11-libs/pango-1.12
		>=x11-libs/cairo-1.1.10
	)
	gts?	( sci-libs/gts )
	lasi?	( media-libs/lasi )
	qt4?	(
		x11-libs/qt-core:4
		x11-libs/qt-gui:4
		>=x11-libs/pango-1.12
		>=x11-libs/cairo-1.1.10
	)
	ruby?	( dev-lang/ruby )
	svg?	( gnome-base/librsvg )
	tcl?	( >=dev-lang/tcl-8.3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex
	java?	( dev-lang/swig )
	nls?	( >=sys-devel/gettext-0.14.5 )
	perl?	( dev-lang/swig )
	python?	( dev-lang/swig )
	ruby?	( dev-lang/swig )
	tcl?	( dev-lang/swig )"

# Dependency description / Maintainer-Info:

# Rendering is done via the following plugins (/plugins):
# - core, dot_layout, neato_layout, gd , dot
#   the ones which are always compiled in, depend on zlib, gd
# - gtk
#   Directly depends on gtk-2.
#   gtk-2 depends on pango, cairo and libX11 directly.
# - gdk-pixbuf
#   Disabled, GTK-1 junk.
# - ming
#   flash plugin via -Tswf requires media-libs/ming-0.4. Disabled as it's
#   incomplete.
# - cairo:
#   Needs pango for text layout, uses cairo methods to draw stuff
# - xlib :
#   needs cairo+pango,
#   can make use of gnomeui and inotify support,
#   needs libXaw for UI
# - qt4 :
#   based on ./configure it needs qt-core and qt-gui only

# There can be swig-generated bindings for the following languages (/tclpkg/gv):
# - c-sharp (disabled)
# - scheme (enabled via guile) ... broken on ~x86
# - io (disabled)
# - java (enabled via java) *2
# - lua (enabled via lua)
# - ocaml (enabled via ocaml)
# - perl (enabled via perl) *1
# - php (enabled via php) *2
# - python (enabled via python) *1
# - ruby (enabled via ruby) *1
# - tcl (enabled via tcl)
# *1 = The ${P}-bindings.patch takes care that those bindings are installed to the right location
# *2 = Those bindings don't build because the paths for the headers/libs aren't
#      detected correctly and/or the options passed to swig are wrong (-php instead of -php4/5)

# There are several other tools in /tclpkg:
# gdtclft, tcldot, tclhandle, tclpathplan, tclstubs ; enabled with: --with-tcl
# tkspline, tkstubs ; enabled with: --with-tk

# And the commands (/cmd):
# - dot, dotty, gvpr, lefty, lneato, tools/* :)
# Lefty needs Xaw and X to build

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-Xaw-configure.patch \
		"${FILESDIR}"/${P}-automake-1.11.2.patch

	# ToDo: Do the same thing for examples and/or
	#       write a patch for a configuration-option
	#       and send it to upstream
	# note - the longer sed expression removes multi-line assignments that are extended via '\'
	if ! use doc ; then
		find . -iname Makefile.am \
			| xargs sed -i -e '/^\(html\|pdf\)_DATA.*\\[[:space:]]*$/{:m;N;s/\\\n//;tm;d}' \
				-e '/^\(html\|pdf\)_DATA/d' || die
	fi

	# This is an old version of libtool
	# use the existing ./configure option to exclude its use, instead of sed'ing it out
	# but delete the dir since we don't need to eautoreconf it
	rm -rf libltdl
	#sed -i -e '/libltdl/d' configure.ac || die
	#sed -i -e 's/AC_LIBLTDL_CONVENIENCE/AC_LIBLTDL_INSTALLABLE/' configure.ac || die

	# no nls, no gettext, no iconv macro, so disable it
	use nls || { sed -i -e '/^AM_ICONV/d' configure.ac || die; }

	# Nuke the dead symlinks for the bindings
	sed -i -e '/$(pkgluadir)/d' tclpkg/gv/Makefile.am || die

	# replace the whitespace with tabs
	sed -i -e 's:  :\t:g' doc/info/Makefile.am || die

	# workaround for http://www.graphviz.org/mantisbt/view.php?id=1895
	use elibc_FreeBSD && append-flags $(test-flags -fno-builtin-sincos)

	eautoreconf
}

src_configure() {
	# libtool file collision, bug 276609
	local myconf="--without-included-ltdl --disable-ltdl-install"

	# Core functionality:
	# All of X, cairo-output, gtk (and probably qt) need the pango+cairo functionality
	if use gtk || use cairo || use qt4; then
		myconf="${myconf} --with-x"
	else
		myconf="${myconf} --without-x"
	fi
	myconf="${myconf}
		$(use_with cairo pangocairo)
		$(use_with devil)
		$(use_with gtk)
		$(use_with gts)
		$(use_with qt4)
		$(use_with lasi)
		$(use_with svg rsvg)
		--with-digcola
		--with-fontconfig
		--with-freetype2
		--with-ipsepcola
		--with-libgd
		--with-sfdp
		--without-gdk-pixbuf
		--without-ming"

	# new/experimental features, to be tested, disable for now
	myconf="${myconf}
		--without-cgraph
		--without-glitz
		--without-ipsepcola
		--without-smyrna
		--without-visio"

	# Bindings:
	myconf="${myconf}
		--disable-guile
		--disable-io
		$(use_enable java)
		--disable-lua
		--disable-ocaml
		$(use_enable perl)
		--disable-php
		$(use_enable python)
		--disable-r
		$(use_enable ruby)
		--disable-sharp
		$(use_enable tcl)"

	econf \
		--enable-ltdl \
		$(use_enable static-libs static) \
		${myconf}
}

src_install() {
	sed -i -e "s:htmldir:htmlinfodir:g" doc/info/Makefile || die

	emake DESTDIR="${D}" \
		txtdir="${EPREFIX}"/usr/share/doc/${PF} \
		htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		htmlinfodir="${EPREFIX}"/usr/share/doc/${PF}/html/info \
		pdfdir="${EPREFIX}"/usr/share/doc/${PF}/pdf \
		pkgconfigdir="${EPREFIX}"/usr/$(get_libdir)/pkgconfig \
		install || die

	use examples || rm -rf "${ED}"/usr/share/graphviz/demo

	use static-libs || find "${ED}" -name '*.la' -exec rm -f {} +

	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	# This actually works if --enable-ltdl is passed
	# to configure
	dot -c
	use python && python_mod_optimize gv.py
}

pkg_postrm() {
	use python && python_mod_cleanup gv.py
}
