# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/bzip2/bzip2-1.0.2-r3.ebuild,v 1.18 2004/12/08 00:42:51 vapier Exp $

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A high-quality data compressor used extensively by Gentoo Linux"
HOMEPAGE="http://sources.redhat.com/bzip2/"
SRC_URI="ftp://sources.redhat.com/pub/bzip2/v102/${P}.tar.gz"

LICENSE="BZIP2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE="build static debug"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	# for optimizations, we keep -fomit-frame-pointer and -fno-strength-reduce
	# for speed.  -fstrength-reduce seems to slow down the code slightly on x86.
	# (drobbins)
	use static && append-flags -static
	use debug && sed -i 's:-fomit-frame-pointer::g' Makefile

	# bzip2 will to run itself after it has built itself which we
	# can't do if we are cross compiling. -solar
	if [ -e /bin/bzip2 ] && [[ ${CTARGET} != ${CHOST} ]] ; then
		sed -i -e 's:./bzip2 -:bzip2 -:g' Makefile || die
	fi
	sed -i \
		-e 's:\$(PREFIX)/man:\$(PREFIX)/share/man:g' \
		-e "s:-O2:${CFLAGS}:g" \
		Makefile || die
	sed -i \
		-e "s:-O2:${CFLAGS}:g" \
		Makefile-libbz2_so || die
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
	emake ${makeopts} all || die "Make failed"
}

src_install() {
	if ! use build ; then
		make PREFIX=${D}/usr install || die
		mv ${D}/usr/bin ${D}

		# These are symlinks to bzip2 ...
		for x in bunzip2 bzcat
		do
			if [ -f "${D}/bin/${x}" ]
			then
				rm -f ${D}/bin/${x}
				dosym bzip2 /bin/${x}
			fi
		done

		[ -z "${CONF_LIBDIR}" ] && CONF_LIBDIR="lib"

		[ "${CONF_LIBDIR}" != "lib" ] && mv ${D}/usr/lib ${D}/usr/${CONF_LIBDIR}
		dolib.so ${S}/libbz2.so.${PV}
		dosym /usr/${CONF_LIBDIR}/libbz2.so.${PV} /usr/${CONF_LIBDIR}/libbz2.so.1.0
		dosym /usr/${CONF_LIBDIR}/libbz2.so.${PV} /usr/${CONF_LIBDIR}/libbz2.so
		dosym /usr/${CONF_LIBDIR}/libbz2.so.${PV} /usr/${CONF_LIBDIR}/libbz2.so.1

		dodoc README LICENSE CHANGES Y2K_INFO
		docinto txt
		dodoc *.txt
		docinto ps
		dodoc *.ps
		dohtml manual_*.html
	else
		into /
		dobin bzip2
		dosym bzip2 /bin/bzcat
		dosym bzip2 /bin/bunzip2
	fi
}
