# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/qtpfsgui/qtpfsgui-2.0_pre691.ebuild,v 1.1 2010/02/14 09:36:23 maekke Exp $

EAPI="2"

inherit eutils qt4

MY_PN="luminance"
MY_PV="${PV/pre/SVN}"
MY_PV="${MY_PV/_/-}"

DESCRIPTION="Qtpfsgui is a graphical user interface that provides a workflow for HDR imaging."
HOMEPAGE="http://qtpfsgui.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LANGS=" cs de es fr it pl ru tr"
IUSE="debug openmp $(echo ${LANGS//\ /\ linguas_})"

DEPEND="
	media-gfx/dcraw
	>=media-gfx/exiv2-0.14
	>=media-libs/jpeg-6b-r7
	>=media-libs/openexr-1.2.2-r2
	>=media-libs/tiff-3.8.2-r2
	>=sci-libs/fftw-3.0.1-r2
	sci-libs/gsl
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-webkit:4
	>=sys-devel/gcc-4.2[openmp?]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_prepare() {
	# no insane CXXFLAGS
	sed -i -e '/QMAKE_CXXFLAGS/d' project.pro || die

	if ! use openmp ; then
		sed -i -e '/QMAKE_LFLAGS/d' project.pro || die
	fi
}

src_compile() {
	lrelease project.pro || die
	eqmake4 project.pro \
		PREFIX=/usr \
		ENABLE_DEBUG="$(use debug && echo YES || echo NO)"
	emake || die
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die
	dodoc README TODO || die

	for lang in ${LANGS} ; do
		use linguas_${lang} || rm "${D}"/usr/share/${MY_PN}/i18n/lang_${lang}.qm
	done
}

pkg_postinst() {
	elog "please note that the binary of this package is now called ${MY_PN}"
	elog "as soon as 2.0 final version is released, the package in portage will"
	elog "be renamed accordingly"
}
