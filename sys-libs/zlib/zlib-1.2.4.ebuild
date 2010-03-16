# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/zlib/zlib-1.2.4.ebuild,v 1.1 2010/03/16 00:35:09 vapier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="http://www.zlib.net/"
SRC_URI="http://www.gzip.org/zlib/${P}.tar.bz2
	http://www.zlib.net/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
# makes xmllint segfault ? #309623
#KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.2.4-build.patch
	epatch "${FILESDIR}"/${PN}-1.2.4-visibility-support.patch #149929
	epatch "${FILESDIR}"/${PN}-1.2.4-LDFLAGS.patch #126718
	epatch "${FILESDIR}"/${PN}-1.2.3-mingw-implib.patch #288212
	# trust exit status of the compiler rather than stderr #55434
	# -if test "`(...) 2>&1`" = ""; then
	# +if (...) 2>/dev/null; then
	sed -i 's|if test "`\(.*\) 2>&1`" = ""; then|if \1 2>/dev/null; then|' configure || die
	sed -i -e '/ldconfig/d' Makefile* || die
}

src_compile() {
	tc-export AR CC RANLIB RC DLLWRAP
	case ${CHOST} in
	*-mingw*|mingw*)
		emake -f win32/Makefile.gcc prefix=/usr || die
		;;
	*)	# not an autoconf script, so cant use econf
		./configure --shared --prefix=/usr --libdir=/usr/$(get_libdir) || die
		emake || die
		;;
	esac
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc FAQ README ChangeLog doc/*.txt

	case ${CHOST} in
	*-mingw*|mingw*)
		dobin zlib1.dll || die
		dolib libz.dll.a || die
		;;
	*) gen_usr_ldscript -a z ;;
	esac
}
