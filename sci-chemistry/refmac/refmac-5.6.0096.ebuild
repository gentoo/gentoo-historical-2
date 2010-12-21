# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/refmac/refmac-5.6.0096.ebuild,v 1.1 2010/12/21 07:39:22 jlec Exp $

EAPI="2"

inherit base toolchain-funcs versionator

MY_PV="$(get_version_component_range 1-2)_source_v${PV}"

DESCRIPTION="Macromolecular crystallographic refinement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~garib/refmac/"
SRC_URI="${HOMEPAGE}data/refmac_experimental/${PN}${MY_PV}.tar.gz
	test? ( http://dev.gentooexperimental.org/~jlec/distfiles/test-framework.tar.gz )"

SLOT="0"
LICENSE="ccp4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	sci-libs/ccp4-libs
	sci-libs/mmdb
	>sci-libs/monomer-db-1
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PV}-allow-dynamic-linking.patch
	)

src_prepare() {
	base_src_prepare
	use test && epatch "${FILESDIR}"/5.5-test.log.patch
}

src_compile() {
	emake \
		FC=$(tc-getFC) \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		COPTIM="${CFLAGS}" \
		FOPTIM="${FFLAGS:- -O2}" \
		VERSION="" \
		XFFLAGS="-fno-second-underscore" \
		LLIBCCP="-lccp4f -lccp4c -lccif -lmmdb -lstdc++" \
		LLIBLAPACK="$(pkg-config --libs lapack blas)" \
		|| die
}

src_test() {
	einfo "Starting tests ..."
	export PATH="${WORKDIR}/test-framework/scripts:${S}:${PATH}"
	export CCP4_TEST="${WORKDIR}"/test-framework
	export CCP4_SCR="${T}"
	ln -sf refmac "${S}"/refmac5
	sed '/^ANISOU/d' -i ${CCP4_TEST}/data/pdb/1vr7.pdb
	ccp4-run-thorough-tests -v test_refmac5 || die
}

src_install() {
	for i in refmac libcheck FreeTwin header2matr; do
		exeinto /usr/libexec/ccp4/bin/
		doexe ${i} || die
		dosym ../libexec/ccp4/bin/${i} /usr/bin/${i}
	done
	dosym refmac /usr/bin/refmac5 || die
}
