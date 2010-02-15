# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/molrep/molrep-10.2.35.ebuild,v 1.2 2010/02/15 19:51:07 jlec Exp $

EAPI="3"

inherit base multilib toolchain-funcs

DESCRIPTION="molecular replacement program"
HOMEPAGE="http://www.ysbl.york.ac.uk/~alexei/molrep.html"
SRC_URI="http://dev.gentooexperimental.org/~jlec/science-dist/${P}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=sci-libs/ccp4-libs-6.1.3
	sci-libs/mmdb
	virtual/lapack"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${PV}-respect-FLAGS.patch
	)

src_compile() {
	cd "${S}"/src
	emake clean || die
	emake \
		MR_FORT=$(tc-getFC) \
		FFLAGS="${FFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		MR_LIBRARY="-L${EPREFIX}/usr/$(get_libdir) -lccp4f -lccp4c -lmmdb -lccif -llapack -lstdc++ -lm" \
		|| die
}

src_install() {
	dobin bin/${PN} || die
	dodoc readme doc/${PN}.rtf || die
}
