# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/optipng/optipng-0.4.5.ebuild,v 1.1 2004/06/02 22:54:30 taviso Exp $

inherit eutils flag-o-matic

DESCRIPTION="PNG optimizing utility"
SRC_URI="http://www.cs.toronto.edu/~cosmin/pngtech/optipng/${P}.tar.gz"
HOMEPAGE="http://www.cs.toronto.edu/~cosmin/pngtech/optipng/"

LICENSE="as-is"

SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha"

IUSE="ext-png ext-zlib mmx"

DEPEND="ext-png? ( media-libs/libpng )
	ext-zlib? ( sys-libs/zlib )
	virtual/glibc"

S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}

	# optionally use the system binaries, rather than the bundled
	# patched versions (some archs/configurations require patches 
	# not included here)
	cd ${S}/src; epatch ${FILESDIR}/${PF}-more-makefile-options.diff
}

src_compile() {
	cd ${S}/src

	append-ldflags -lm

	# use libpng's mmx makefile if requested
	if use mmx; then

		# do amd64/ia64 support mmx?
		use x86 || ewarn "mmx flag set, but not on x86?"

		pngmake=makefile.gcmmx
	else
		pngmake=makefile.gcc
	fi

	# only defined in bundled zlib?
	if use ext-zlib || use ext-png; then
		append-flags -DZ_RLE=3
	fi

	export pngmake LDFLAGS

	# some logic to decide which version to build...
	if ! use ext-png; then
		if ! use ext-zlib; then
			# use the included patched zlib/libpng
			einfo "Building ${PN} with bundled libraries..."
			emake -f scripts/Makefile.gcc optipng
		else
			# use the system zlib.
			einfo "Building ${PN} with bundled libpng..."
			emake -f scripts/Makefile.gcc optipng-extzlib
		fi
	else
		if use ext-zlib; then
			# use the system zlib and libpng.
			einfo "Building ${PN} without bundled libraries..."
			emake -f scripts/Makefile.gcc optipng-allext
		else
			# use the system libpng.
			einfo "Building ${PN} with bundled zlib..."
			emake -f scripts/Makefile.gcc optipng-extpng
		fi
	fi

	# some feedback everything went ok...
	echo; ls -l optipng; size optipng
}

src_install() {
	dobin ${S}/src/optipng
	dodoc ${S}/doc/{CAVEAT,DESIGN,FEATURES,HISTORY,LICENSE,README,TODO,USAGE}
	dohtml ${S}/doc/index.html
}
