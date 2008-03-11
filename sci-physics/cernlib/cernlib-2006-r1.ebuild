# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/cernlib/cernlib-2006-r1.ebuild,v 1.1 2008/03/11 12:09:06 bicatali Exp $

inherit eutils multilib fortran

DEB_PN=cernlib
DEB_PV=${PV}.dfsg.2
DEB_PR=11
DEB_P=${DEB_PN}_${DEB_PV}

DESCRIPTION="CERN program library for High Energy Physics"
HOMEPAGE="http://wwwasd.web.cern.ch/wwwasd/cernlib"
SRC_URI="mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}.orig.tar.gz
	mirror://debian/pool/main/${DEB_PN:0:1}/${DEB_PN}/${DEB_P}-${DEB_PR}.diff.gz"

KEYWORDS="~amd64 ~sparc ~x86"
LICENSE="GPL-2 LGPL-2 BSD"

SLOT="0"

DEPEND="virtual/motif
	virtual/lapack
	virtual/latex-base
	dev-lang/cfortran
	x11-misc/imake
	x11-misc/makedepend
	dev-util/pkgconfig"

RDEPEND="virtual/motif
	virtual/lapack
	dev-lang/cfortran"

IUSE=""

S="${WORKDIR}/${DEB_PN}-${DEB_PV}.orig"

FORTRAN="gfortran g77 ifc"

src_unpack() {

	unpack ${A}
	epatch "${DEB_P}-${DEB_PR}".diff
	cd "${S}"

	# set some default paths
	sed -i \
		-e "s:/usr/local:/usr:g" \
		-e "s:prefix)/lib:prefix)/$(get_libdir):" \
		-e 's:$(prefix)/etc:/etc:' \
		-e 's:$(prefix)/man:$(prefix)/share/man:' \
		debian/add-ons/cernlib.mk || die "sed failed"

	# use system blas and lapack set by gentoo framework
	sed -i \
		-e "s:\$DEPS -lm:$(pkg-config --libs blas):" \
		-e "s:\$DEPS -llapack -lm:$(pkg-config --libs lapack):" \
		-e 's:`depend $d $a blas`::' \
		-e "s:X11R6:X11:g" \
		debian/add-ons/bin/cernlib.in || die "sed failed"

	cp debian/add-ons/Makefile .
	export DEB_BUILD_OPTIONS="${FORTRANC} nostrip nocheck"

	einfo "Applying Debian patches"
	emake -j1 patch || die "debian patch failed"

	# since we depend on cfortran, do not use the one from cernlib
	rm -f src/include/cfortran/cfortran.h \

	# fix an ifort problem
	sed -i \
		-e 's/= $(CLIBS) -nofor_main/:= $(CLIBS) -nofor_main/' \
		src/packlib/kuip/programs/kxterm/Imakefile || die "sed ifc failed"

	# respect users flags
	sed -i \
		-e 's/-O3/-O2/g' \
		-e "s/-O2/${CFLAGS}/g" \
		src/config/linux.cf	|| die "sed linux.cf failed"
}

src_compile() {
	# create local LaTeX cache dir
	mkdir -p .texmf-var
	emake -j1 cernlib-indep cernlib-arch || die "emake libs failed"
}

src_test() {
	LD_LIBRARY_PATH="${S}"/shlib \
		emake -j1 cernlib-test || die "emake test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	cd "${S}"/debian
	dodoc changelog README.* deadpool.txt NEWS copyright || die "dodoc failed"
	newdoc add-ons/README README.add-ons || die "newdoc failed"
}

pkg_postinst() {
	elog "Gentoo ${PN} is based on Debian similar package."
	elog "Serious cernlib users might want to check:"
	elog "http://people.debian.org/~kmccarty/cernlib/"
	elog "for the changes and licensing from the original package"
	if use amd64; then
		elog "Please see the possible warnings for ${PN} on 64 bits:"
		elog "${ROOT}/usr/share/doc/${PF}/README.*64*"
	fi
}
