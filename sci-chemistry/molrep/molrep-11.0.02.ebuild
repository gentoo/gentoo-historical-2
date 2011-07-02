# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/molrep/molrep-11.0.02.ebuild,v 1.8 2011/07/02 08:55:01 jlec Exp $

EAPI="3"

inherit eutils fortran-2 multilib toolchain-funcs

DESCRIPTION="molecular replacement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~alexei/molrep.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	virtual/fortran

	>=sci-libs/ccp4-libs-6.1.3
	sci-libs/mmdb
	virtual/lapack"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/11.0.00-respect-FLAGS.patch
	epatch "${FILESDIR}"/11.0.00-test.patch
}

src_compile() {
	cd "${S}"/src
	emake clean || die
	emake \
		MR_FORT="$(tc-getFC) ${FFLAGS}" \
		FFLAGS="${FFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		MR_LIBRARY="-L${EPREFIX}/usr/$(get_libdir) -lccp4f -lccp4c $(pkg-config --libs mmdb lapack) -lccif -lstdc++ -lm" \
		|| die
}

src_test() {
	export MR_TEST="${S}/bin/"
	cd "${S}"/molrep_check/work
	mkdir out scr
	cp ../*.bat .
	bash em.bat || die
	bash mr.bat || die
}

src_install() {
	exeinto /usr/libexec/ccp4/bin/
	doexe bin/${PN} || die
	dosym ../libexec/ccp4/bin/${PN} /usr/bin/${PN}
	dodoc readme doc/${PN}.rtf || die
}
