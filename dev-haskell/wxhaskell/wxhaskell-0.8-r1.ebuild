# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-haskell/wxhaskell/wxhaskell-0.8-r1.ebuild,v 1.8 2006/02/19 18:50:26 dcoutts Exp $

inherit flag-o-matic wxwidgets ghc-package

DESCRIPTION="a portable and native GUI library for Haskell"
HOMEPAGE="http://wxhaskell.sourceforge.net/"
SRC_URI="mirror://sourceforge/wxhaskell/${PN}-src-${PV}.zip"
LICENSE="wxWinLL-3"
SLOT="0"

KEYWORDS="~x86 ~ppc -amd64"

IUSE="doc"

RDEPEND=">=virtual/ghc-6.2
	!>=virtual/ghc-6.4
	=x11-libs/wxGTK-2.4*"

DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( >=dev-haskell/haddock-0.6-r2 )"

pkg_setup() {
	if ! built_with_use x11-libs/wxGTK X; then
		einfo "wxhaskell needs wxGTK that has been built with X11 support."
		einfo "Please re-emerge wxGTK with USE=\"X -odbc -unicode\""
		die "wxhaskell requires wxGTK to be built with USE=\"X -odbc -unicode\""
	fi
	if built_with_use x11-libs/wxGTK odbc; then
		einfo "Sadly wxhaskell does not work with wxGTK that has been built"
		einfo "with USE=\"odbc\"."
		einfo "Please re-emerge wxGTK with USE=\"-odbc\""
		die "wxhaskell requires wxGTK to be built with USE=\"-odbc\""
	fi
}

src_unpack() {
	unpack ${A}
	# adapt to Gentoo path convention
	sed -i 's:/doc/html:/share/doc/html:' ${S}/configure
	# fix superfluous dependencies on hslibs packages
	sed -i -e 's:,lang::' -e 's:,"lang"::' \
		-e 's:,concurrent::' -e 's:,"concurrent"::' ${S}/configure
	# fix Makefile to respect CXXFLAGS
	sed -i 's:^\(WXC-CXXFLAGS.*=\):\1\$(CXXFLAGS) :' ${S}/makefile
}

src_compile() {
	ghc-setup-pkg

	#wxhaskell supports gtk or gtk2, but not unicode yet. However since the gtk2
	#USE flag is deprecated we now only build with gtk2:
	WX_GTK_VER=2.4
	need-wxwidgets gtk2

	# every C compiler result ends up in a shared lib
	append-flags -fPIC

	# non-standard configure, so econf is not an option
	# --wx-config must appear first according to configure file comments 
	./configure \
		--wx-config="${WX_CONFIG}" \
		--prefix=/usr \
		--with-opengl \
		--libdir=/usr/lib/${P} \
		--package-conf=${S}/$(ghc-localpkgconf) \
		|| die "./configure failed"

	emake -j1 || die "make failed"

	# create documentation
	if use doc; then
		emake -j1 doc || die "make doc failed"
	fi
}

src_install() {
	local f

	# don't register the packages, just install the files
	emake -j1 install-files DESTDIR="${D}" || die "make install failed"

	# the .so needs to be on the lib path
	mkdir -p ${D}/usr/lib
	for f in ${D}/usr/lib/${P}/libwxc-*.so; do
		mv ${f} ${D}/usr/lib/
	done

	if use doc; then
		dohtml -A haddock -r out/doc/*
		cp -r samples ${D}/usr/share/doc/${PF}
	fi

	# substitute for the ${wxhlibdir} in package files and register them
	sed -i -e "s:\${wxhlibdir}:${D}/usr/lib/${P}:" ${D}/usr/lib/${P}/*.pkg
	ghc-setup-pkg ${D}/usr/lib/${P}/*.pkg
	ghc-install-pkg
}
