# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/namd/namd-2.6_beta1.ebuild,v 1.3 2005/12/22 16:32:19 markusle Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="A powerful and highly parallelized molecular dynamics code"
LICENSE="namd"
HOMEPAGE="http://www.ks.uiuc.edu/Research/namd/"

MY_PN="NAMD"
MY_PV="2.6b1"

SRC_URI="${MY_PN}_${MY_PV}_Source.tar.gz"

SLOT="0"
KEYWORDS="~x86"
IUSE="hardened"

RESTRICT="fetch"

DEPEND="|| ( app-shells/csh
			app-shells/tcsh )
	virtual/libc
	=sys-cluster/charm-5.9
	=sci-libs/fftw-2*
	=dev-lang/tcl-8.4*
	hardened? ( sys-apps/paxctl )"

CHARM="charm-5.9"
NAMD_ARCH="Linux-i686-g++"

NAMD_DOWNLOAD="http://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=NAMD"

S="${WORKDIR}/${MY_PN}_${MY_PV}_Source"

pkg_nofetch() {
	echo
	einfo "Please download ${MY_PN}_${MY_PV}_Source.tar.gz from"
	einfo "${NAMD_DOWNLOAD}"
	einfo "after agreeing to the license and then move it to"
	einfo "${DISTDIR}"
	einfo "Be sure to select the ${MY_PV} version!"
	echo
}

src_unpack() {
	unpack ${A}

	# apply a few small fixes to make NAMD compile and
	# link to the proper libraries
	epatch "${FILESDIR}"/namd-barrier-fix-gentoo.patch
	epatch "${FILESDIR}"/namd-tcl-lib-gentoo.patch
	epatch "${FILESDIR}"/namd-fftw-lib-gentoo.patch
	epatch "${FILESDIR}"/namd-makefile-gentoo.patch

	cd "${S}"

	# for hardened turn ssp off
	if use hardened; then
		append-flags -fno-stack-protector-all
	fi

	# proper compiler and cflags
	sed -e "s/g++/$(tc-getCXX)/" \
		-e "s/CXXOPTS = -O3 -march=pentiumpro -ffast-math -static/CXXOPTS = ${CXXFLAGS}/" \
		-e "s/gcc/$(tc-getCC)/" \
		-e "s/COPTS = -O3 -march=pentiumpro -ffast-math -static/COPTS = ${CFLAGS}/" \
		-i arch/${NAMD_ARCH}.arch || \
		die "Failed to setup ${NAMD_ARCH}.arch"

	# configure
	./config tcl fftw ${NAMD_ARCH}
}

src_compile() {
	# build namd
	cd "${S}/${NAMD_ARCH}"
	emake || die "Failed to build namd"

	# for hardened disable MPROTECT on namd2 binary
	if use hardened; then
		/sbin/paxctl -PemRxS ./namd2 || \
			die "paxctl failed on namd2"
	fi
}

src_install() {
	cd "${S}/${NAMD_ARCH}"

	# the binaries
	dobin ${PN}2 psfgen flipbinpdb flipdcd || \
		die "Failed to install binaries"

	cd "${S}"

	# some docs
	dodoc announce.txt license.txt notes.txt || \
		die "Failed to install docs"
}

pkg_postinst() {
	echo
	einfo "For detailed instructions on how to run and configure"
	einfo "NAMD please consults the extensive documentation at"
	einfo "http://www.ks.uiuc.edu/Research/namd/"
	einfo "and the NAMD tutorials available at"
	einfo "http://www.ks.uiuc.edu/Training/Tutorials/"
	einfo "Have fun :)"
	echo
}
