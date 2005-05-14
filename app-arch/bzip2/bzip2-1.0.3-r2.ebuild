# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/bzip2/bzip2-1.0.3-r2.ebuild,v 1.1 2005/05/14 17:36:14 vapier Exp $

inherit multilib toolchain-funcs flag-o-matic

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="http://www.bzip.org/"
SRC_URI="http://www.bzip.org/${PV}/${P}.tar.gz"

LICENSE="BZIP2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="build static"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.0.2-NULL-ptr-check.patch
	epatch "${FILESDIR}"/${P}-makefile-CFLAGS.patch
	epatch "${FILESDIR}"/${P}-saneso.patch
	epatch "${FILESDIR}"/${PN}-1.0.2-progress.patch
	sed -i -e 's:\$(PREFIX)/man:\$(PREFIX)/share/man:g' Makefile || die "sed manpath"

	# - Generate symlinks instead of hardlinks
	# - pass custom variables to control libdir
	sed -i \
		-e 's:ln $(PREFIX)/bin/:ln -s :' \
		-e 's:$(PREFIX)/lib:$(PREFIX)/$(LIBDIR):g' \
		Makefile || die "sed links"

	# bzip2 will to run itself after it has built itself which we
	# can't do if we are cross compiling. -solar
	if [[ -x /bin/bzip2 ]] && tc-is-cross-compiler ; then
		sed -i -e 's:./bzip2 -:bzip2 -:g' Makefile || die "sed cross-compile"
	fi
}

src_compile() {
	local makeopts="
		CC=$(tc-getCC)
		AR=$(tc-getAR)
		RANLIB=$(tc-getRANLIB)
	"
	if ! use build ; then
		emake ${makeopts} -f Makefile-libbz2_so all || die "Make failed libbz2"
	fi
	use static && append-flags -static
	emake ${makeopts} all || die "Make failed"
}

src_install() {
	if ! use build ; then
		make PREFIX="${D}"/usr LIBDIR=$(get_libdir) install || die

		# move bzip2 binaries to / and use the shared libbz2.so
		mv "${D}"/usr/bin "${D}"/
		into /
		if ! use static ; then
			newbin bzip2-shared bzip2 || die "dobin shared"
		fi
		dolib.so "${S}"/libbz2.so.${PV} || die "dolib shared"
		for v in ${PV%%.*} ${PV%.*} ; do
			dosym libbz2.so.${PV} /$(get_libdir)/libbz2.so.${v}
		done

		dodoc README* CHANGES Y2K_INFO bzip2.txt manual.*
	else
		into /
		dobin bzip2 || die "dobin bzip2"
	fi

	dosym bzip2 /bin/bzcat
	dosym bzip2 /bin/bunzip2
}
