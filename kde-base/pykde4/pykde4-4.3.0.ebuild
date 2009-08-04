# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/pykde4/pykde4-4.3.0.ebuild,v 1.1 2009/08/04 01:33:28 wired Exp $

EAPI="2"

KMNAME="kdebindings"
KMMODULE="python/${PN}"
OPENGL_REQUIRED="always"
inherit python kde4-meta

DESCRIPTION="Python bindings for KDE4"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="akonadi debug examples policykit semantic-desktop"

COMMON_DEPEND="
	>=dev-python/PyQt4-4.5[dbus,sql,svg,webkit,X]
	>=kde-base/kdelibs-${PV}:${SLOT}[kdeprefix=,opengl,semantic-desktop?]
	akonadi? ( >=kde-base/kdepimlibs-${PV}:${SLOT}[kdeprefix=] )
	policykit? ( >=sys-auth/policykit-qt-0.9.2 )
"
DEPEND="${COMMON_DEPEND}"
# blocker added due to compatibility issues and error during compile time
RDEPEND="${COMMON_DEPEND}
	!dev-python/pykde
"

#PATCHES=(
#	"${FILESDIR}/${PN}-installation-fix.patch"
#)

src_prepare() {
	kde4-meta_src_prepare

	if ! use examples; then
		sed -e '/^ADD_SUBDIRECTORY(examples)/s/^/# DISABLED /' -i python/${PN}/CMakeLists.txt \
			|| die "Failed to disable examples"
	fi
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DWITH_QScintilla=OFF
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with akonadi)
		$(cmake-utils_use_with akonadi KdepimLibs)
		$(cmake-utils_use_with policykit PolkitQt)
	"

	kde4-meta_src_configure
}

src_install() {
	kde4-meta_src_install

	python_version
	rm -f \
		"${D}/usr/$(get_libdir)/python${PYVER}"/site-packages/PyKDE4/*.py[co] \
		"${D}${PREFIX}"/share/apps/"${PN}"/*.py[co]
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	python_mod_optimize ${ROOT}"usr/$(get_libdir)/python${PYVER}"/site-packages/PyKDE4

	if use examples; then
		echo
		elog "PyKDE4 examples have been installed to"
		elog "${PREFIX}/share/apps/${PN}/examples"
		echo
	fi
}

pkg_postrm() {
	kde4-meta_pkg_postrm

	python_mod_cleanup ${ROOT}"usr/$(get_libdir)/python${PYVER}"/site-packages/PyKDE4
}
