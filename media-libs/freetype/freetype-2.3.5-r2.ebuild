# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/freetype/freetype-2.3.5-r2.ebuild,v 1.1 2007/10/04 01:07:25 dirtyepic Exp $

inherit eutils flag-o-matic libtool

DESCRIPTION="A high-quality and portable font engine"
HOMEPAGE="http://www.freetype.org/"
SRC_URI="mirror://sourceforge/freetype/${P/_/}.tar.bz2
	utils?	( mirror://sourceforge/freetype/ft2demos-${PV}.tar.bz2 )
	doc?	( mirror://sourceforge/freetype/${PN}-doc-${PV}.tar.bz2 )"

LICENSE="FTL GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="X bindist debug doc utils"

DEPEND="X?	( x11-libs/libX11
			  x11-libs/libXau
			  x11-libs/libXdmcp )"

# We also need a recent fontconfig version to prevent segfaults. #166029
# July 3 2007 dirtyepic
RDEPEND="${DEPEND}
		!<media-libs/fontconfig-2.3.2-r2"

src_unpack() {
	unpack ${A}
	cd "${S}"

	enable_option() {
		sed -i -e "/#define $1/a #define $1" \
			include/freetype/config/ftoption.h \
			|| die "unable to enable option $1"
	}

	disable_option() {
		sed -i -e "/#define $1/ { s:^:/*:; s:$:*/: }" \
			include/freetype/config/ftoption.h \
			|| die "unable to disable option $1"
	}

	if ! use bindist; then
		# Bytecodes and subpixel hinting supports are patented
		# in United States; for safety, disable them while building
		# binaries, so that no risky code is distributed.
		# See http://freetype.org/patents.html

		enable_option FT_CONFIG_OPTION_SUBPIXEL_RENDERING
		enable_option TT_CONFIG_OPTION_BYTECODE_INTERPRETER
		disable_option TT_CONFIG_OPTION_UNPATENTED_HINTING
	fi

	if use debug; then
		enable_option FT_DEBUG_LEVEL_ERROR
		enable_option FT_DEBUG_MEMORY
	fi

	enable_option FT_CONFIG_OPTION_INCREMENTAL
	disable_option FT_CONFIG_OPTION_OLD_INTERNALS

	epatch "${FILESDIR}"/${PN}-2.3.2-enable-valid.patch
	epatch "${FILESDIR}"/${PN}-2.3.5-crossbuild.patch		# bug #185681

	if use utils; then
		cd "${WORKDIR}"/ft2demos-${PV}
		sed -i -e "s:\.\.\/freetype2$:../freetype-${PV}:" Makefile

		# Disable tests needing X11 when USE="-X". (bug #177597)
		if ! use X; then
			sed -i -e "/EXES\ +=\ ftview/ s:^:#:" Makefile
		fi
	fi

	elibtoolize
	epunt_cxx
}

src_compile() {
	append-flags -fno-strict-aliasing

	type -P gmake &> /dev/null && export GNUMAKE=gmake
	econf || die "econf failed"
	emake || die "emake failed"

	if use utils; then
		cd "${WORKDIR}"/ft2demos-${PV}
		emake || die "ft2demos emake failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ChangeLog README
	dodoc docs/{CHANGES,CUSTOMIZE,DEBUG,*.txt,PATENTS,TODO}

	use doc && dohtml -r docs/*

	if use utils; then
		rm "${WORKDIR}"/ft2demos-${PV}/bin/README
		for ft2demo in ../ft2demos-${PV}/bin/*; do
			./builds/unix/libtool --mode=install $(type -P install) -m 755 "$ft2demo" \
				"${D}"/usr/bin
		done
	fi
}

pkg_postinst() {
	echo
	ewarn "After upgrading to freetype-2.3.5, it is necessary to rebuild"
	ewarn "libXfont to avoid build errors in some packages."
	echo
	elog "The utilities and demos previously bundled with freetype are now"
	elog "optional.  Enable the utils USE flag if you would like them"
	elog "to be installed."
	echo
}
