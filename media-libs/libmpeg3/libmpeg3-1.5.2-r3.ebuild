# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmpeg3/libmpeg3-1.5.2-r3.ebuild,v 1.14 2007/02/17 00:47:42 flameeyes Exp $

inherit flag-o-matic eutils toolchain-funcs

PATCHLEVEL="3"
DESCRIPTION="An mpeg library for linux"
HOMEPAGE="http://heroinewarrior.com/libmpeg3.php3"
SRC_URI="mirror://sourceforge/heroines/${P}-src.tar.bz2
	mirror://gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2
	mirror://gentoo/${P}-textrel-fix.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sh sparc x86"
IUSE="mmx"

RDEPEND="sys-libs/zlib
	media-libs/jpeg
	media-libs/a52dec"
DEPEND="${RDEPEND}
	mmx? ( dev-lang/nasm )"

pkg_setup() {
	if use x86; then
		if is-flagq -O3 || is-flagq -finline-functions; then
			# with flag -fforce-addr we have too less registers for mmx-asm-code on x86 (Bug #141323)
			is-flagq -fforce-addr && einfo "Removing flag -fforce-addr to get enough registers for mmx-code."
			filter-flags -fforce-addr
		fi
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	if [[ $(gcc-version) == "3.3" ]]; then
		eerror "You're using an old version of GCC, but this package is"
		eerror "designed to work only with GCC 3.4 or later."
		eerror "Please upgrade your GCC or change the selected profile"
		eerror "and then merge this again."
		die "Package won't build with GCC 3.3."
	fi

	# The Makefile is patched to install the header files as well.
	# This patch was generated using the info in the src.rpm that
	# SourceForge provides for this package.
	[ "`gcc-version`" == "3.4" -o "`gcc-major-version`" -ge 4 ] || \
		EPATCH_EXCLUDE="${EPATCH_EXCLUDE} 08_all_gcc34.patch"
	[ "`gcc-major-version`" -ge 4 ] || \
		EPATCH_EXCLUDE="${EPATCH_EXCLUDE} 09_all_gcc4.patch"

	EPATCH_SUFFIX="patch" epatch ${WORKDIR}/${PV}

	sed -i -e "/LIBS = /s:$: -la52:" Makefile

	epatch "${FILESDIR}/${P}-a52.patch"
	epatch "${FILESDIR}/${P}-gnustack.patch"
	epatch "${DISTDIR}/${P}-textrel-fix.patch.bz2"
	epatch "${FILESDIR}/${P}-soname.patch"

	if ! use mmx; then
		sed -i -e 's:^NASM =.*:NASM =:' \
			-e 's|^HAVE_NASM :=.*|HAVE_NASM=n|' \
			-e 's|USE_MMX = 1|USE_MMX = 0|' \
			Makefile
	fi
}

src_compile() {
	local obj_dir=$(uname --machine)

	mkdir $obj_dir

	rm -f ${obj_dir}/*.o &> /dev/null

	emake CC="$(tc-getCC)" || die "make failed"
}

src_install() {
	# This patch patches the .h files that get installed into /usr/include
	# to show the correct include syntax '<>' instead of '""'  This patch
	# was also generated using info from SF's src.rpm
	epatch ${WORKDIR}/${PV}/gentoo-p2.patch
	make DESTDIR="${D}/usr" LIBDIR="$(get_libdir)" install || die
	dohtml -r docs
}
