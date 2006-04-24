# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libpng/libpng-1.2.8-r1.ebuild,v 1.14 2006/04/24 02:21:19 kumba Exp $

inherit flag-o-matic eutils toolchain-funcs multilib

DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="http://www.libpng.org/"
SRC_URI="mirror://sourceforge/libpng/${P}.tar.bz2
	doc? ( http://www.libpng.org/pub/png/libpng-manual.txt )"

LICENSE="as-is"
SLOT="1.2"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc-macos ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="doc"

DEPEND="sys-libs/zlib"

src_unpack() {
	unpack ${P}.tar.bz2
	cd "${S}"
	use doc && cp "${DISTDIR}"/libpng-manual.txt .

	epatch "${FILESDIR}"/1.2.7-gentoo.diff
	cp scripts/makefile.linux{,.orig}
	epatch "${FILESDIR}"/${PN}-1.2.8-strnlen.patch
	epatch "${FILESDIR}"/${PN}-1.2.8-build.patch

	[[ $(gcc-version) == "3.3" || $(gcc-version) == "3.2" ]] \
		&& replace-cpu-flags k6 k6-2 k6-3 i586

	local makefilein
	case ${CHOST} in
		*-darwin*) makefilein="scripts/makefile.darwin";;
		*)         makefilein="scripts/makefile.linux";;
	esac
	sed \
		-e "/^ZLIBLIB=/s:=.*:=:" \
		-e "/^ZLIBINC=/s:=.*:=:" \
		-e "/^LIBPATH=/s:/lib:/$(get_libdir):" \
		-e 's:mkdir:mkdir -p:' \
		${makefilein} > Makefile || die

	sed -i -e "s:libdir=\${exec_prefix}/lib:libdir=/usr/$(get_libdir):" \
		scripts/${PN}.pc.in || die
}

src_compile() {
	tc-export CC RANLIB AR
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc ANNOUNCE CHANGES KNOWNBUG README TODO Y2KINFO
	use doc && dodoc libpng-manual.txt
}

pkg_postinst() {
	# the libpng authors really screwed around between 1.2.1 and 1.2.3
	if [[ -f ${ROOT}/usr/$(get_libdir)/libpng.so.3.1.2.1 ]] ; then
		rm -f "${ROOT}"/usr/$(get_libdir)/libpng.so.3.1.2.1
	fi
}
