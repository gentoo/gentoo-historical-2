# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/iozone/iozone-3.218.ebuild,v 1.3 2004/06/24 21:28:04 agriffis Exp $

IUSE=""

inherit eutils

DESCRIPTION="Filesystem benchmarking program."
HOMEPAGE="http://www.iozone.org/"
SRC_URI="http://www.iozone.org/src/current/${PN}${PV/./_}.tar"
LICENSE="freedist"
SLOT="0"

# TODO
#        ->   linux-arm            (32bit)   <-
#        ->   linux-AMD64          (64bit)   <-
#        ->   linux-ia64           (64bit)   <-
#        ->   linux-powerpc        (32bit)   <-
#        ->   linux-S390           (32bit)   <-
#        ->   linux-S390X          (64bit)   <-
#
#        ->   macosx               (32bit)   <-
#        ->   netbsd               (32bit)   <-
#        ->   openbsd              (32bit)   <-
#        ->   openbsd-threads      (32bit)   <-
#
#
# ~arm ~amd64 ~ia64 ~s390 alpha(?)

KEYWORDS="~x86 ~ppc ~sparc"


DEPEND="sys-devel/gcc
	>=sys-apps/sed-4
	virtual/glibc"

RDEPEND="virtual/glibc"

S=${WORKDIR}

src_compile() {

	cd src/current

	# Options FIX
	sed -i -e "s:[/a-z]*cc.*-c.*-Dunix:${CC} ${CFLAGS} -Dunix -c:g" \
		-e "s:[/a-z]*cc.*-Dunix:${CC} ${CFLAGS} -Dunix:g" makefile

	case ${ARCH} in
		x86|alpha)
			PLATFORM="linux"
			;;
		ppc)
			PLATFORM="linux-powerpc"
			;;
		amd64)
			PLATFORM="linux-AMD64"
			;;
		s390)
			PLATFORM="linux-S390"
			;;
		*)
			PLATFORM="linux-${ARCH}"
			;;
	esac

	emake ${PLATFORM} || die "Compile failed"
}

src_install() {
	dosbin src/current/iozone
	dodoc docs/I*
	dodoc docs/Run_rules.doc
	dodoc src/current/Changes.txt
	doman docs/iozone.1

	dodir /usr/share/${PF}
	insinto /usr/share/${PF}
	cd src/current
	doins Generate_Graphs Gnuplot.txt gengnuplot.sh gnu3d.dem

	prepall
}

src_test() {

	cd ${T}
	${S}/src/current/iozone testfile || die "self test failed"

}
