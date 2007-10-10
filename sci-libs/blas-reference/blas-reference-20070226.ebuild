# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/blas-reference/blas-reference-20070226.ebuild,v 1.12 2007/10/10 12:30:50 bicatali Exp $

inherit eutils autotools fortran multilib flag-o-matic

LAPACKPV="3.1.1"
LAPACKPN="lapack-lite"

DESCRIPTION="Basic Linear Algebra Subprograms F77 reference implementations"
LICENSE="public-domain"
HOMEPAGE="http://www.netlib.org/blas/"
SRC_URI="http://www.netlib.org/lapack/${LAPACKPN}-${LAPACKPV}.tgz"

SLOT="0"
IUSE="doc"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"

DEPEND="app-admin/eselect-blas
	doc? ( app-doc/blas-docs )"

RDEPEND="${DEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${LAPACKPN}-${LAPACKPV}"

pkg_setup() {
	FORTRAN="g77 gfortran ifc"
	fortran_pkg_setup
	if  [[ ${FORTRANC} == if* ]]; then
		ewarn "Using Intel Fortran at your own risk"
		LDFLAGS="$(raw-ldflags)"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-autotool.patch
	eautoreconf
}

src_compile() {
	econf \
		--libdir=/usr/$(get_libdir)/blas/reference \
		|| die "econf failed"
	emake LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	ESELECT_PROF=reference
	eselect blas add $(get_libdir) "${FILESDIR}"/eselect.blas.reference ${ESELECT_PROF}
}

pkg_postinst() {
	local p=blas
	local current_lib=$(eselect ${p} show | cut -d' ' -f2)
	if [[ ${current_lib} == ${ESELECT_PROF} || -z ${current_lib} ]]; then
		# work around eselect bug #189942
		local configfile="${ROOT}"/etc/env.d/${p}/lib/config
		[[ -e ${configfile} ]] && rm -f ${configfile}
		eselect ${p} set ${ESELECT_PROF}
		elog "${p} has been eselected to ${ESELECT_PROF}"
	else
		elog "Current eselected ${p} is ${current_lib}"
		elog "To use ${p} ${ESELECT_PROF} implementation, you have to issue (as root):"
		elog "\t eselect ${p} set ${ESELECT_PROF}"
	fi
}
