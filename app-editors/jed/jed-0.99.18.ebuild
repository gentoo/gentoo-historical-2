# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/jed/jed-0.99.18.ebuild,v 1.7 2008/02/09 23:00:22 ranger Exp $

inherit versionator

MY_P=${PN}-$(replace_version_separator 2 '-')
DESCRIPTION="Console S-Lang-based editor"
HOMEPAGE="http://www.jedsoft.org/jed/"
SRC_URI="ftp://space.mit.edu/pub/davis/jed/v0.99/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE="X gpm truetype"

RDEPEND=">=sys-libs/slang-2
	X? ( x11-libs/libX11 x11-libs/libXext x11-libs/libXrender
		truetype? ( virtual/xft	>=media-libs/freetype-2.0 ) )
	gpm? ( sys-libs/gpm )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	export JED_ROOT=/usr/share/jed

	econf --prefix=${JED_ROOT} \
		--bindir=/usr/bin || die

	if use gpm ; then
		sed -i	-e 's/#MOUSEFLAGS/MOUSEFLAGS/' \
			-e 's/#MOUSELIB/MOUSELIB/' \
			-e 's/#GPMMOUSEO/GPMMOUSEO/' \
			-e 's/#OBJGPMMOUSEO/OBJGPMMOUSEO/' \
			src/Makefile
	fi

	if use X && use truetype ; then
	   sed -i -e 's/#XRENDERFONTLIBS/XRENDERFONTLIBS/' src/Makefile
	   sed -i -e 's/^CONFIG_H = config.h/xterm_C_FLAGS = `freetype-config --cflags`\nCONFIG_H = config.h/' src/Makefile
	   sed -i -e 's/#define XJED_HAS_XRENDERFONT 0/#define XJED_HAS_XRENDERFONT 1/' src/jed-feat.h
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
	cd "${S}/src"
	make DESTDIR="${D}" install || die

	cd "${S}"
	dodoc INSTALL INSTALL.unx README changes.txt doc/manual/jed.tex
	newdoc doc/README AUTHORS

	doinfo info/jed*

	insinto /etc
	doins lib/jed.conf

	# replace IDE mode with EMACS mode
	sed -i -e 's/\(_Jed_Default_Emulation = \).*/\1"emacs";/' \
		"${D}"/etc/jed.conf || die "patching jed.conf failed"

	rm -rf "${D}"/usr/share/jed/info
	# can't rm usr/share/jed/doc -- used internally by jed/xjed
}
