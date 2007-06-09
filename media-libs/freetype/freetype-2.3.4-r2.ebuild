# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/freetype/freetype-2.3.4-r2.ebuild,v 1.8 2007/06/09 00:09:19 dirtyepic Exp $

inherit eutils flag-o-matic libtool

DESCRIPTION="A high-quality and portable font engine"
HOMEPAGE="http://www.freetype.org/"
SRC_URI="mirror://sourceforge/freetype/${P/_/}.tar.bz2
	mirror://sourceforge/freetype/ft2demos-${PV}.tar.gz
	doc? ( mirror://sourceforge/${PN}/${PN}-doc-${PV}.tar.bz2 )"

LICENSE="FTL GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="X bindist debug doc zlib"

# The RDEPEND below makes sure that if there is a version of moz/ff/tb
# installed, then it will have the freetype-2.1.8+ binary compatibility patch.
# Otherwise updating freetype will cause moz/ff/tb crashes.  #59849
# 20 Nov 2004 agriffis
DEPEND="zlib? ( sys-libs/zlib )
		X?    ( x11-libs/libX11 )"

RDEPEND="${DEPEND}
	!<www-client/mozilla-1.7.3-r3
	!<www-client/mozilla-firefox-1.0-r3
	!<mail-client/mozilla-thunderbird-0.9-r3
	!<media-libs/libwmf-0.2.8.2
	>=media-libs/fontconfig-2.4.0"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Bug #179161
	epatch "${FILESDIR}"/${P}-CVE-2007-2754.patch

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

		enable_option TT_CONFIG_OPTION_BYTECODE_INTERPRETER
		enable_option FT_CONFIG_OPTION_SUBPIXEL_RENDERING
		disable_option TT_CONFIG_OPTION_UNPATENTED_HINTING
	fi

	if use debug; then
		enable_option FT_DEBUG_LEVEL_ERROR
		enable_option FT_DEBUG_MEMORY
	fi

	enable_option FT_CONFIG_OPTION_INCREMENTAL
	disable_option FT_CONFIG_OPTION_OLD_INTERNALS

	epatch "${FILESDIR}"/${PN}-2.3.2-enable-valid.patch

	### ft2demos ###
		cd ../ft2demos-${PV}

		epatch "${FILESDIR}"/${PN}-2.3.3-ft2demos-Makefile.patch
		sed -i -e "s:\.\.\/freetype2$:../freetype-${PV}:" Makefile

		# Disable tests needing X11 when USE="-X". (bug #177597)
		if ! use X; then
			sed -i -e "/EXES\ +=\ ftview/ s:^:#:" Makefile
		fi

		cd ${S}
	### end ft2demos ###

	elibtoolize
	epunt_cxx
}

src_compile() {
	# https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=118021
	append-flags "-fno-strict-aliasing"

	type -P gmake &> /dev/null && export GNUMAKE=gmake
	econf $(use_with zlib) || die "econf failed"
	emake || die "emake failed"

	cd ../ft2demos-${PV}
	emake || die "ft2demos emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ChangeLog README
	dodoc docs/{CHANGES,CUSTOMIZE,DEBUG,*.txt,PATENTS,TODO}

	#cd "${WORKDIR}"/${PN}-doc-${PV}
	use doc && dohtml -r docs/*

	rm ../ft2demos-${PV}/bin/README
	for ft2demo in ../ft2demos-${PV}/bin/*; do
		./builds/unix/libtool --mode=install $(type -P install) -m 755 $ft2demo \
			${D}/usr/bin
	done
}
