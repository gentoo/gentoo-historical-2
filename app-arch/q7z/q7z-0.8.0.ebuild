# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/q7z/q7z-0.8.0.ebuild,v 1.2 2010/03/20 19:03:20 spatz Exp $

EAPI="2"
PYTHON_DEPEND="2"
inherit eutils python

MY_PN="Q7Z"

DESCRIPTION="A GUI frontend for p7zip"
HOMEPAGE="http://code.google.com/p/k7z/"
SRC_URI="http://k7z.googlecode.com/files/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

RESTRICT="test"

DEPEND="app-arch/p7zip
	dev-python/PyQt4[X]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}/Build"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	cd ..

	# fix paths used at runtime
	epatch "${FILESDIR}/${PV}-fix_paths.patch"
	# remove '-r' flag from 7z as it's not supposed to be used
	epatch "${FILESDIR}/${PV}-fix_7z_flags.patch"
	# fix imports to reference the q7z package
	epatch "${FILESDIR}/${PV}-fix_imports.patch"

	# patch menu entry to have correct name
	mv "Desktop/Menu/${MY_PN}.desktop" "Desktop/Menu/${PN}.desktop"
	sed -i "s/${MY_PN}/${PN}/" "Desktop/Menu/${PN}.desktop" \
		|| die "sed failed"

	python_convert_shebangs -r 2 .

	cd Source
	mv "${MY_PN}.pyw" "${PN}.pyw"
}

src_install() {
	cd ..

	insinto "$(python_get_sitedir)/${PN}"
	doins Source/*.py || die
	newins "${FILESDIR}/${PV}-init.py" __init__.py || die

	insinto "/usr/share/${PN}/Options"
	doins Options/* || die
	insinto "/usr/share/${PN}/Profiles"
	doins Desktop/Profiles/* || die

	dobin "Source/${PN}.pyw" || die
	dosym "/usr/bin/${PN}.pyw" "/usr/bin/${PN}" || die

	# install menu entry
	insinto /usr/share/icons/hicolor/32x32/apps
	newins "Image/apps/${MY_PN}.png" "${PN}.png" || die
	domenu "Desktop/Menu/${PN}.desktop" || die
}

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/${PN}"
}

pkg_postrm() {
	python_mod_cleanup
}
