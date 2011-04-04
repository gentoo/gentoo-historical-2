# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/votca-csg/votca-csg-1.1.2.ebuild,v 1.1 2011/04/04 20:05:31 ottxor Exp $

EAPI="3"

inherit autotools-utils bash-completion

MANUAL_PV=1.1
if [ "${PV}" != "9999" ]; then
	SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz
		doc? ( http://votca.googlecode.com/files/votca-manual-${MANUAL_PV}.pdf )"
	RESTRICT="primaryuri"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://csg.votca.googlecode.com/hg"
	S="${WORKDIR}/${EHG_REPO_URI##*/}"
	PDEPEND="doc? ( =app-doc/votca-manual-${PV} )"
fi

DESCRIPTION="Votca coarse-graining engine"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +gromacs static-libs"

RDEPEND="=sci-libs/votca-tools-${PV}
	gromacs? ( >=sci-chemistry/gromacs-4.0.7-r5 )
	dev-lang/perl
	app-shells/bash"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[-nodot] )
	>=app-text/txt2tags-2.5
	dev-util/pkgconfig"

src_prepare() {
	#from bootstrap.sh
	if [ -z "${PV##*9999}" ]; then
		emake -C share/scripts/inverse -f Makefile.am.in Makefile.am || die
	fi

	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	local libgmx

	#in >gromacs-4.5 libgmx was renamed to libgromacs
	has_version =sci-chemistry/gromacs-9999 && libgmx="libgromacs" || libgmx="libgmx"
	#prefer gromacs double-precision if it is there
	has_version sci-chemistry/gromacs[double-precision] && libgmx="${libgmx}_d"

	myeconfargs=( ${myconf} --disable-rc-files  $(use_with gromacs libgmx $libgmx) )
	autotools-utils_src_configure || die
}

src_install() {
	DOCS=(README NOTICE ${AUTOTOOLS_BUILD_DIR}/CHANGELOG)
	dobashcompletion scripts/csg-completion.bash ${PN} || die
	autotools-utils_src_install || die
	if use doc; then
		if [ -n "${PV##*9999}" ]; then
			dodoc "${DISTDIR}/votca-manual-${MANUAL_PV}.pdf" || die
		fi
		cd share/doc || die
		doxygen || die
		dohtml -r html/* || die
	fi
}

pkg_postinst() {
	elog
	elog "Please read and cite:"
	elog "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	elog "http://dx.doi.org/10.1021/ct900369w"
	elog
	bash-completion_pkg_postinst
}
