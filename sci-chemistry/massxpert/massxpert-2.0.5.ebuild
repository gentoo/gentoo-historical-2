# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/massxpert/massxpert-2.0.5.ebuild,v 1.1 2009/09/19 19:30:25 ayoy Exp $

EAPI="2"

inherit cmake-utils

DESCRIPTION="A software suite to predict/analyze mass spectrometric data on (bio)polymers."
HOMEPAGE="http://massxpert.org"
SRC_URI="http://download.tuxfamily.org/${PN}/source/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="x11-libs/qt-svg:4[debug?]"
DEPEND="${DEPEND}
	doc? ( virtual/latex-base )"

MASSXPERT_LANGS="fr"

for L in ${MASSXPERT_LANGS}; do
	IUSE="${IUSE} linguas_${L}"
done

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch"

	local langs=
	for lingua in ${LINGUAS}; do
		if has ${lingua} ${MASSXPERT_LANGS}; then
			langs="${langs} ${PN}_${lingua}.qm"
		fi
	done

	sed -i -e "s/\(SET (massxpert_TRANSLATIONS \).*/\1${langs})/" \
		gui/CMakeLists.txt || die "setting up translations failed"
}

src_configure() {
	filter-ldflags -Wl,--as-needed --as-needed

	mycmakeargs="
		-DBUILD_PROGRAM=1
		-DBUILD_DATA=1"
	use doc && mycmakeargs="${mycmakeargs} -DBUILD_USERMANUAL=1"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon "gui/images/${PN}-icon-32.xpm" || die "installing icon failed"
	dodoc TODO || die "dodoc failed"
}
