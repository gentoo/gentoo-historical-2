# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/apbs/apbs-1.2.1b-r2.ebuild,v 1.2 2010/03/30 07:02:46 jlec Exp $

EAPI="3"

PYTHON_DEPEND="2"
FORTRAN="g77 gfortran ifc"

inherit autotools eutils flag-o-matic fortran python versionator

MY_PV=$(get_version_component_range 1-3)
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Software for evaluating the electrostatic properties of nanoscale biomolecular systems"
HOMEPAGE="http://apbs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.gz"

SLOT="0"
LICENSE="BSD"
IUSE="arpack blas doc mpi openmp python tools"
KEYWORDS="~x86 ~amd64 ~ppc ~amd64-linux ~x86-linux"

DEPEND="
	dev-libs/maloc[mpi=]
	blas? ( virtual/blas )
	python? ( dev-lang/python )
	sys-libs/readline
	arpack? ( sci-libs/arpack )
	mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${MY_P}-source"

src_prepare() {
	epatch "${FILESDIR}"/${P}-openmp.patch
	epatch "${FILESDIR}"/${P}-install-fix.patch
	epatch "${FILESDIR}"/${PN}-1.2.0-contrib.patch
	epatch "${FILESDIR}"/${PN}-1.2.0-link.patch
	epatch "${FILESDIR}"/${P}-autoconf-2.64.patch
	sed "s:GENTOO_PKG_NAME:${PN}:g" \
		-i Makefile.am || die "Cannot correct package name"
	eautoreconf
	find . -name "._*" -exec rm -f '{}' \;
}

src_configure() {
	local myconf="--docdir=${EPREFIX}/usr/share/doc/${PF}"
	use blas && myconf="${myconf} --with-blas=-lblas"
	use arpack && myconf="${myconf} --with-arpack=${EPREFIX}/usr/$(get_libdir)"

	# check which mpi version is installed and tell configure
	if use mpi; then
		export CC="${EPREFIX}/usr/bin/mpicc"
		export F77="${EPREFIX}/usr/bin/mpif77"

		if has_version sys-cluster/mpich; then
	 		myconf="${myconf} --with-mpich=${EPREFIX}/usr"
		elif has_version sys-cluster/mpich2; then
			myconf="${myconf} --with-mpich2=${EPREFIX}/usr"
		elif has_version sys-cluster/lam-mpi; then
			myconf="${myconf} --with-lam=${EPREFIX}/usr"
		elif has_version sys-cluster/openmpi; then
			myconf="${myconf} --with-openmpi=${EPREFIX}/usr"
		fi
	fi || die "Failed to select proper mpi implementation"

	# we need the tools target for python
	if use python && ! use tools; then
		myconf="${myconf} --enable-tools"
	fi

	econf \
		--disable-maloc-rebuild \
		$(use_enable openmp) \
		$(use_enable python) \
		$(use_enable tools) \
		${myconf}
}

src_compile() {
	emake -j1 || die "make failed"
}

src_test() {
	cd examples && make test \
		|| die "Tests failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install \
		|| die "make install failed"

	if use tools; then
		mv tools/mesh/{,mesh-}analysis || die
		dobin tools/mesh/* || die

		if use arpack; then
			dobin tools/arpack/* || die
		fi

		insinto /usr/share/${PN}
		doins -r tools/conversion || die
		doins -r tools/visualization/opendx || die

		dobin tools/manip/{born,coulomb} || die

		doins -r tools/matlab || die
	fi

	insinto /usr/$(python_get_sitedir)/${PN}
	doins tools/manip/*.py || die

	if use python && ! use mpi; then
		insinto /usr/$(python_get_sitedir)/${PN}
		doins tools/python/{*.py,*.pqr,*.so} || die
		doins tools/python/*/{*.py,*.so} || die
	fi

	dodoc AUTHORS INSTALL README NEWS ChangeLog \
		|| die "Failed to install docs"

	if use doc; then
		dohtml -r doc/* || die "Failed to install html docs"
	fi
}

pkg_postinst() {
	python_mod_optimize /usr/$(python_get_sitedir)/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/$(python_get_sitedir)/${PN}
}
