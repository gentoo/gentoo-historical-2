# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/jed/jed-0.99.16-r2.ebuild,v 1.20 2007/02/09 21:29:28 grobian Exp $

inherit eutils

P0=${PN}-0.99-16
S=${WORKDIR}/${P0}
DESCRIPTION="Console S-Lang-based editor"
HOMEPAGE="http://www.jedsoft.org/jed/"
SRC_URI="ftp://ftp.uni-stuttgart.de/pub/unix/misc/slang/jed/v0.99/${P0}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="X gpm truetype"

RDEPEND="<sys-libs/slang-2
	X? ( || (
			( x11-libs/libX11 x11-libs/libXext x11-libs/libXrender )
			  virtual/x11
		)
	)
	gpm? ( sys-libs/gpm )
	X? ( truetype? ( || ( x11-libs/libXft virtual/xft )
					>=media-libs/freetype-2.0 ) )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

PROVIDE="virtual/editor"

src_unpack() {
	unpack ${A}
	cd ${S}; epatch ${FILESDIR}/${P}-jed.info.patch
	use userland_Darwin && epatch ${FILESDIR}/${P}-darwin.patch
}

src_compile() {
	export JED_ROOT=/usr/share/jed

	./configure	--host=${CHOST} \
		--prefix=$JED_ROOT \
		--bindir=/usr/bin \
		--mandir=/usr/share/man || die

	if use gpm ; then
		cd src
		sed -i	-e 's/#MOUSEFLAGS/MOUSEFLAGS/' \
			-e 's/#MOUSELIB/MOUSELIB/' \
			-e 's/#GPMMOUSEO/GPMMOUSEO/' \
			-e 's/#OBJGPMMOUSEO/OBJGPMMOUSEO/' \
			Makefile
		cd ${S}
	fi

	if use X && use truetype ; then
	   cd src
	   sed -i -e 's/#XRENDERFONTLIBS/XRENDERFONTLIBS/' Makefile
	   sed -i -e 's/^CONFIG_H = config.h/xterm_C_FLAGS = `freetype-config --cflags`\nCONFIG_H = config.h/' Makefile
	   sed -i -e 's/#define XJED_HAS_XRENDERFONT 0/#define XJED_HAS_XRENDERFONT 1/' jed-feat.h
	   cd ${S}
	fi

	make clean || die

	emake || die

	if use X ; then
		emake xjed || die
	fi
}

src_install() {
	# make install in ${S} claims everything is up-to-date,
	# so we manually cd ${S}/src before installing
	cd ${S}/src
	make DESTDIR=${D} install || die

	cd ${S}/doc
	cp README AUTHORS

	cd ${S}
	dodoc INSTALL INSTALL.unx README doc/AUTHORS doc/manual/jed.tex

	cd ${S}/info
	rm info.info
	epatch ${FILESDIR}/jed.info.diff
	cd ${S}

	insinto /usr/share/info
	doins info/*

	insinto /etc
	doins lib/jed.conf

	# replace IDE mode with EMACS mode
	sed -i -e 's/\(_Jed_Default_Emulation = \).*/\1"emacs";/' ${D}/etc/jed.conf || die "patching jed.conf failed"

	cd ${D}
	rm -rf usr/share/jed/info
	# can't rm usr/share/jed/doc -- used internally by jed/xjed
}
