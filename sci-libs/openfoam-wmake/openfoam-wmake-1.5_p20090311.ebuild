# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/openfoam-wmake/openfoam-wmake-1.5_p20090311.ebuild,v 1.2 2009/09/25 09:30:31 flameeyes Exp $

EAPI="2"

inherit eutils versionator multilib toolchain-funcs

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-2)
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenFOAM - wmake"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz -> ${MY_P}.General.tgz
	http://omploader.org/vMWRlMQ/${MY_PN}-git-${PVR}.patch
	http://omploader.org/vMWRlMA/${MY_P}-svn.patch
	mirror://gentoo/${MY_P}-compile-2.patch.bz2"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="examples doc"

DEPEND="!=sci-libs/openfoam-${MY_PV}*
	!=sci-libs/openfoam-bin-${MY_PV}*
	virtual/mpi
	|| ( >sci-visualization/paraview-3.0 sci-visualization/opendx )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	# just to be sure the right profile is selected (gcc-config)
	if ! version_is_at_least 4.1 $(gcc-version) ; then
		die "${PN} requires >=sys-devel/gcc-4.1 to compile."
	fi

	elog
	elog "In order to use ${MY_PN} you should add the following line to ~/.bashrc :"
	elog "source /usr/$(get_libdir)/${MY_PN}/bashrc"
	ewarn
	ewarn "FoamX is deprecated since ${MY_PN}-1.5! "
	ewarn
}

src_prepare() {
	epatch "${DISTDIR}"/${MY_P}-compile-2.patch.bz2
	epatch "${DISTDIR}"/${MY_P}-svn.patch
	epatch "${DISTDIR}"/${MY_PN}-git-${PVR}.patch
}

src_compile() {
	if has_version sys-cluster/lam-mpi ; then
		export WM_MPLIB=LAM
	elif has_version sys-cluster/mpich2 ; then
		export WM_MPLIB=MPICH
	elif has_version sys-cluster/openmpi ; then
		export WM_MPLIB=OPENMPI
	else
		die "You need one of the following mpi implementations: openmpi, lam-mpi or mpich2"
	fi

	sed -i -e "s|WM_MPLIB:=OPENMPI|WM_MPLIB:="${WM_MPLIB}"|" etc/bashrc
	sed -i -e "s|setenv WM_MPLIB OPENMPI|setenv WM_MPLIB "${WM_MPLIB}"|" etc/cshrc

	export FOAM_INST_DIR="${WORKDIR}"
	source etc/bashrc

	find wmake -name dirToString | xargs rm -rf
	find wmake -name wmkdep | xargs rm -rf

	cd wmake/src
	emake || die "could not build wmake"
}

src_test() {
	cd bin
	./foamInstallationTest
}

src_install() {
	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}
	doins -r etc

	rm -rf tutorials/rhoPorousSimpleFoam/angledDuctExplicit/{0,constant}
	cp -a tutorials/rhoPorousSimpleFoam/angledDuctImplicit/{0,constant} tutorials/rhoPorousSimpleFoam/angledDuctExplicit
	use examples && doins -r tutorials

	insopts -m0755
	doins -r bin

	insinto /usr/$(get_libdir)/${MY_PN}/${MY_P}/wmake
	doins -r wmake/*

	insopts -m0644
	insinto /usr/share/doc/${PF}
	doins doc/Guides-a4/*.pdf
	dodoc README

	if use doc ; then
		dohtml -r doc/Doxygen
	fi

	dosym /usr/$(get_libdir)/${MY_PN}/${MY_P}/etc/bashrc /usr/$(get_libdir)/${MY_PN}/bashrc
	dosym /usr/$(get_libdir)/${MY_PN}/${MY_P}/etc/cshrc /usr/$(get_libdir)/${MY_PN}/cshrc
}
