# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/wxpython/wxpython-2.9.1.1.ebuild,v 1.4 2012/01/06 21:25:12 hwoarang Exp $

EAPI="3"
PYTHON_DEPEND="2"
WX_GTK_VER="2.9"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit alternatives eutils fdo-mime flag-o-matic python wxwidgets

MY_P="${P/wxpython-/wxPython-src-}"

DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="http://www.wxpython.org/"
SRC_URI="mirror://sourceforge/wxpython/${MY_P}.tar.bz2
	examples? ( mirror://sourceforge/wxpython/wxPython-demo-${PV}.tar.bz2 )"

LICENSE="wxWinLL-3"
SLOT="2.9"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="cairo examples opengl"

RDEPEND="
	dev-python/setuptools
	>=x11-libs/wxGTK-${PV}:${WX_GTK_VER}[opengl?,tiff,X]
	>=x11-libs/gtk+-2.4:2
	>=x11-libs/pango-1.2
	dev-libs/glib:2
	media-libs/libpng
	virtual/jpeg
	media-libs/tiff
	cairo?	( >=dev-python/pycairo-1.8.4 )
	opengl?	( >=dev-python/pyopengl-2.0.0.44 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}/wxPython"
DOC_S="${WORKDIR}/wxPython-${PV}"

src_prepare() {
	sed -i "s:cflags.append('-O3'):pass:" config.py || die "sed failed"

	epatch "${FILESDIR}"/${PN}-${SLOT}-wxversion-scripts.patch
	# drop editra - we have it as a separate package now
	epatch "${FILESDIR}"/${PN}-2.8.11-drop-editra.patch

	if use examples; then
		cd "${DOC_S}"
		epatch "${FILESDIR}"/${PN}-${SLOT}-wxversion-demo.patch
	fi

	python_copy_sources
}

src_configure() {
	need-wxwidgets unicode

	append-flags -fno-strict-aliasing

	use opengl \
		&& mypyconf="${mypyconf} BUILD_GLCANVAS=1" \
		|| mypyconf="${mypyconf} BUILD_GLCANVAS=0"

	mypyconf="${mypyconf} WX_CONFIG=${WX_CONFIG}"
	mypyconf="${mypyconf} WXPORT=gtk2 UNICODE=1"
}

src_compile() {
	building() {
		"$(PYTHON)" setup.py ${mypyconf} build
	}
	python_execute_function -s building
}

src_install() {
	local file mypyconf

	mypyconf="${mypyconf} WX_CONFIG=${WX_CONFIG}"
	use opengl \
		&& mypyconf="${mypyconf} BUILD_GLCANVAS=1" \
		|| mypyconf="${mypyconf} BUILD_GLCANVAS=0"

	mypyconf="${mypyconf} WXPORT=gtk2 UNICODE=1"

	installation() {
		"$(PYTHON)" setup.py ${mypyconf} install --root="${D}" --install-purelib $(python_get_sitedir)
	}
	python_execute_function -s installation

	# this should be temporary
	dobin "${S}"/scripts/pyslices || die
	dobin "${S}"/scripts/pysliceshell || die

	# Collision protection.
	for file in "${D}"/usr/bin/*; do
		mv "${file}" "${file}-${SLOT}" || die
	done
	rename_files() {
		for file in "${D}$(python_get_sitedir)/"wx{version.*,.pth}; do
			mv "${file}" "${file}-${SLOT}" || return 1
		done
	}
	python_execute_function -q rename_files

	dodoc "${S}"/docs/{CHANGES,PyManual,README,wxPackage,wxPythonManual}.txt

	insinto /usr/share/applications
	for x in {Py{AlaMode,Crust,Shell,Slices{,Shell}},XRCed}; do
		newins "${S}"/distrib/${x}.desktop ${x}-${SLOT}.desktop || die
	done
	insinto /usr/share/pixmaps
	newins "${S}"/wx/py/PyCrust_32.png PyCrust-${SLOT}.png || die
	newins "${S}"/wx/py/PySlices_32.png PySlices-${SLOT}.png || die
	newins "${S}"/wx/tools/XRCed/XRCed_32.png XRCed-${SLOT}.png || die

	if use examples; then
		dodir /usr/share/doc/${PF}/demo || die
		dodir /usr/share/doc/${PF}/samples || die
		cp -R "${DOC_S}"/demo/* "${D}"/usr/share/doc/${PF}/demo/ || die
		cp -R "${DOC_S}"/samples/* "${D}"/usr/share/doc/${PF}/samples/ || die
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	create_symlinks() {
		alternatives_auto_makesym "$(python_get_sitedir)/wx.pth" "$(python_get_sitedir)/wx.pth-[0-9].[0-9]"
		alternatives_auto_makesym "$(python_get_sitedir)/wxversion.py" "$(python_get_sitedir)/wxversion.py-[0-9].[0-9]"
	}
	python_execute_function -q create_symlinks

	python_mod_optimize wx-2.9.1-gtk2 wxversion.py

	echo
	elog "Gentoo uses the Multi-version method for SLOT'ing."
	elog "Developers, see this site for instructions on using"
	elog "2.6 or 2.8 with your apps:"
	elog "http://wiki.wxpython.org/index.cgi/MultiVersionInstalls"
	elog
	if use examples; then
		elog "The demo.py app which contains hundreds of demo modules"
		elog "with documentation and source code has been installed at"
		elog "/usr/share/doc/${PF}/demo/demo.py"
		elog
		elog "Many more example apps and modules can be found in"
		elog "/usr/share/doc/${PF}/samples/"
	fi
	echo
	elog "Editra is no longer packaged with wxpython in Gentoo."
	elog "You can find it in the tree as app-editors/editra"
	echo
}

pkg_postrm() {
	python_mod_cleanup wx-2.9.1-gtk2 wxversion.py
	fdo-mime_desktop_database_update

	create_symlinks() {
		alternatives_auto_makesym "$(python_get_sitedir)/wx.pth" "$(python_get_sitedir)/wx.pth-[0-9].[0-9]"
		alternatives_auto_makesym "$(python_get_sitedir)/wxversion.py" "$(python_get_sitedir)/wxversion.py-[0-9].[0-9]"
	}
	python_execute_function -q create_symlinks
}
