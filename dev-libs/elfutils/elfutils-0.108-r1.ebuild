# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/elfutils/elfutils-0.108-r1.ebuild,v 1.4 2005/12/10 13:51:23 solar Exp $

inherit eutils

DESCRIPTION="Libraries/utilities to handle ELF objects (drop in replacement for libelf)"
HOMEPAGE="http://people.redhat.com/drepper/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	http://dev.gentoo.org/~azarah/${PN}/${P}-robustify3.patch.bz2
	mirror://gentoo/${P}-robustify3.patch.bz2"

LICENSE="OpenSoftware"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="nls"

# This pkg does not actually seem to compile currently in a uClibc
# environment (xrealloc errs), but we need to ensure that glibc never
# gets pulled in as a dep since this package does not respect virtual/libc
DEPEND="elibc_glibc? ( >=sys-libs/glibc-2.3.2 )
	nls? ( sys-devel/gettext )
	sys-devel/autoconf
	>=sys-devel/binutils-2.14.90.0.6
	>=sys-devel/gcc-3.2.1-r6
	!dev-libs/libelf"
RDEPEND=""

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.101-bswap.patch
	epatch "${FILESDIR}"/${P}-portability.patch

	# The next patch should not be needed in 0.109
	epatch ${DISTDIR}/${P}-robustify3.patch.bz2

	# Needed by ${P}-portability.patch
	autoreconf || die

	find . -name Makefile.in -print0 | xargs -0 sed -i -e 's:-W\(error\|extra\)::g'
}

src_compile() {
	econf \
		--program-prefix="eu-" \
		--enable-shared \
		$(use_enable nls) \
		|| die "./configure failed"
	emake || die
}

src_test() {
	env LD_LIBRARY_PATH="${S}/libelf:${S}/libebl:${S}/libdw:${S}/libasm" \
		make check || die "test failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS NOTES README THANKS TODO
}
