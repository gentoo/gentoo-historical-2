# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/jed/jed-0.99.16-r1.ebuild,v 1.13 2004/04/20 09:00:17 liquidx Exp $

IUSE="X gpm truetype"

P0=${PN}-0.99-16
S=${WORKDIR}/${P0}
DESCRIPTION="Console S-Lang-based editor"
SRC_URI="ftp://ftp.uni-stuttgart.de/pub/unix/misc/slang/jed/v0.99/${P0}.tar.bz2"
HOMEPAGE="http://www.jedsoft.org/jed/"

DEPEND=">=sys-libs/slang-1.4.5
	>=sys-apps/sed-4
	X? ( virtual/x11 )
	gpm? ( sys-libs/gpm )
	X? ( truetype? ( virtual/xft
		>=media-libs/freetype-2.0 ) )"

PROVIDE="virtual/editor"

SLOT="0"
KEYWORDS="x86 ppc sparc amd64"
LICENSE="GPL-2"

src_compile() {
	export JED_ROOT=/usr/share/jed

	./configure	--host=${CHOST} \
		--prefix=$JED_ROOT \
		--bindir=/usr/bin \
		--mandir=/usr/share/man || die

	if [ -n "`use gpm`" ] ; then
		cd src
		sed -i	-e 's/#MOUSEFLAGS/MOUSEFLAGS/' \
			-e 's/#MOUSELIB/MOUSELIB/' \
			-e 's/#GPMMOUSEO/GPMMOUSEO/' \
			-e 's/#OBJGPMMOUSEO/OBJGPMMOUSEO/' \
			Makefile
		cd ${S}
	fi

	if [ -n "`use X`" -a -n "`use truetype`" ]; then
	   cd src
	   sed -i -e 's/#XRENDERFONTLIBS/XRENDERFONTLIBS/' Makefile
	   sed -i -e 's/^CONFIG_H = config.h/xterm_C_FLAGS = `freetype-config --cflags`\nCONFIG_H = config.h/' Makefile
	   sed -i -e 's/#define XJED_HAS_XRENDERFONT 0/#define XJED_HAS_XRENDERFONT 1/' jed-feat.h
	   cd ${S}
	fi

	make clean || die

	emake || die

	if [ -n "`use X`" ] ; then
		emake xjed || die
	fi
}

src_install () {
	make DESTDIR=${D} install || die

	cd doc
	cp README AUTHORS

	cd ${S}
	dodoc 	COPYING COPYRIGHT INSTALL INSTALL.unx README \
		doc/AUTHORS doc/manual/jed.tex

	cd ${S}/info
	rm info.info
	patch < ${FILESDIR}/jed.info.diff || die
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


