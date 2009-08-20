# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/allpaths/allpaths-2.0.ebuild,v 1.3 2009/08/20 16:56:10 weaver Exp $

EAPI="2"

inherit base

DESCRIPTION="De novo assembly of whole-genome shotgun microreads"
HOMEPAGE="http://www.broadinstitute.org/science/programs/genome-biology/crd"
SRC_URI="ftp://ftp.broad.mit.edu/pub/crd/ALLPATHS/Release-2-0/allpaths-2.0.tar.gz
	ftp://ftp.broad.mit.edu/pub/crd/ALLPATHS/Release-2-0/allpaths-2.0.manual.docx"

LICENSE="Whitehead-MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

# TODO: info message on failure instructing to run gcc-config
DEPEND=">=sys-devel/gcc-4.3.2"
RDEPEND=""

PATCHES=(
	"${FILESDIR}"/${P}-gcc-x86-no-autocast.patch
)

S="${WORKDIR}"

src_prepare() {
	base_src_prepare
	rm -rf libxerces* xerces_include || die
}

src_install() {
	rm -rf bin/auxfiles
	exeinto /usr/share/${PN}/bin
	doexe bin/* || die
	echo "PATH=\"/usr/share/${PN}/bin\"" > "${S}/99${PN}"
	doenvd "${S}/99${PN}" || die
	dosym /usr/share/${PN}/bin/RunAllPaths /usr/bin/RunAllPaths || die
	insinto /usr/share/doc/${PF}
	doins "${DISTDIR}/${P}.manual.docx"
}
