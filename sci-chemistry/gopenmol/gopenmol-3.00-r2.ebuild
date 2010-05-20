# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/gopenmol/gopenmol-3.00-r2.ebuild,v 1.2 2010/05/20 11:41:03 jlec Exp $

EAPI="3"

PYTHON_DEPEND="2"

inherit eutils multilib prefix python

DESCRIPTION="Tool for the visualization and analysis of molecular structures"
HOMEPAGE="http://www.csc.fi/gopenmol"
SRC_URI="${HOMEPAGE}/distribute/${P}-linux.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	=dev-lang/tk-8.4*
	dev-tcltk/bwidget
	media-libs/jpeg
	virtual/glut
	virtual/opengl
	x11-libs/libICE
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXxf86vm"

DEPEND="${RDEPEND}"

S="${WORKDIR}/gOpenMol-${PV}/src"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-include-config-for-plugins.patch
	epatch "${FILESDIR}"/${PV}-multilib.patch

	sed \
		-e "s:GENTOOLIBDIR:$(get_libdir):g" \
		-i config.mk.ac plugins/config.mk.ac
	sed "/GOM_TEMP/s:^.*$:GOM_TEMP=\"${EPREFIX}/tmp/:g" -i ../environment.txt || die
}

src_compile() {
	emake || die "emake failed"

	# Plugins are not built by default
	cd "${S}"/plugins
	emake || die "emake plugins failed"

	# Utilities are not built by default
	cd "${S}"/utility
	emake || die "emake utility failed"
}

src_install() {
	einstall || die "einstall failed"

	cd "${S}"/plugins
	einstall || die "einstall plugins failed"

	cd "${S}"/utility
	einstall || die "einstall utility failed"

	dosed /usr/bin/rungOpenMol

	dosym ../$(get_libdir)/gOpenMol-${PV}/bin/${PN} /usr/bin/${PN}

	dodoc "${ED}"/usr/share/gOpenMol-${PV}/{docs/*,README*} || die

	dodir /usr/share/doc/${PF}/html
	mv -T "${ED}"/usr/share/gOpenMol-${PV}/help "${ED}"/usr/share/doc/${PF}/html || die
	mv "${ED}"/usr/share/gOpenMol-${PV}/utility "${ED}"/usr/share/doc/${PF}/html || die

	rm -rf \
		"${ED}"/usr/$(get_libdir)/gOpenMol-${PV}/{src,install} \
		"${ED}"/usr/share/gOpenMol-${PV}/{docs,README*,COPYRIGHT} || die

	cat >> "${T}"/20${PN} <<- EOF
	GOM_ROOT="${EPREFIX}"/usr/$(get_libdir)/gOpenMol-${PV}/
	GOM_DATA="${EPREFIX}"/usr/share/gOpenMol-${PV}/data
	GOM_HELP="${EPREFIX}"/usr/share/doc/${PVR}/html
	GOM_DEMO="${EPREFIX}"/usr/share/gOpenMol-${PV}/demo
	EOF

	doenvd "${T}"/20${PN}
}

pkg_postinst() {
	einfo "Run gOpenMol using the rungOpenMol script."
}
