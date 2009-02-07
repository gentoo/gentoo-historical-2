# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/wxpython/wxpython-2.8.9.1-r3.ebuild,v 1.5 2009/02/07 19:50:48 armin76 Exp $

EAPI="2"
WX_GTK_VER="2.8"

inherit alternatives eutils multilib python wxwidgets flag-o-matic
# We don't use distutils.eclass because it doesn't seem to play nice with
# need-wxwidgets

MY_P="${P/wxpython-/wxPython-src-}"
DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="http://www.wxpython.org/"
SRC_URI="mirror://sourceforge/wxpython/${MY_P}.tar.bz2
		doc? ( mirror://sourceforge/wxpython/wxPython-docs-${PV}.tar.bz2
				mirror://sourceforge/wxpython/wxPython-newdocs-${PV}.tar.bz2 )
		examples? ( mirror://sourceforge/wxpython/wxPython-demo-${PV}.tar.bz2 )"

LICENSE="wxWinLL-3"
SLOT="2.8"
KEYWORDS="~alpha ~amd64 arm hppa ~ia64 ~ppc ~ppc64 sh ~sparc ~x86 ~x86-fbsd"
IUSE="cairo opengl doc examples"

RDEPEND=">=x11-libs/wxGTK-${PV}:2.8[opengl?]
	>=dev-lang/python-2.4
	>=x11-libs/gtk+-2.4
	>=x11-libs/pango-1.2
	>=dev-libs/glib-2.0
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	cairo? ( dev-python/pycairo )
	opengl? ( >=dev-python/pyopengl-2.0.0.44 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}/wxPython/"
DOC_S="${WORKDIR}/wxPython-${PV}"

src_prepare() {
	sed -i "s:cflags.append('-O3'):pass:" config.py || die "sed failed"

	epatch "${FILESDIR}"/${PN}-2.8.8-wxversion-scripts.patch

	if use doc; then
		cd "${DOC_S}"
		epatch "${FILESDIR}"/${PN}-${SLOT}-cache-writable.patch
	fi

	if use examples; then
		cd "${DOC_S}"
		epatch "${FILESDIR}"/${PN}-${SLOT}-wxversion-demo.patch
	fi
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
	python setup.py ${mypyconf} build || die "setup.py build failed"
}

src_install() {
	local mypyconf
	python_version
	local site_pkgs=/usr/$(get_libdir)/python${PYVER}/site-packages

	mypyconf="${mypyconf} WX_CONFIG=${WX_CONFIG}"
	use opengl \
		&& mypyconf="${mypyconf} BUILD_GLCANVAS=1" \
		|| mypyconf="${mypyconf} BUILD_GLCANVAS=0"

	mypyconf="${mypyconf} WXPORT=gtk2 UNICODE=1"

	python setup.py ${mypyconf} install --root="${D}" \
		--install-purelib ${site_pkgs} || die "setup.py install failed"

	# Collision protection.
	for file in "${D}"/usr/bin/* "${D}"/${site_pkgs}/wx{version.*,.pth}; do
		mv "${file}" "${file}-${SLOT}"
	done

	for dir in "${D}"/${site_pkgs}/wx-${SLOT}-gtk2-{ansi,unicode}; do
		if [[ -d ${dir} ]]; then
			cp -R "${D}"/${site_pkgs}/wxaddons/ "${dir}"
			wxaddons_copied=1
		fi
	done

	[[ ${wxaddons_copied} ]] && rm -rf "${D}"/${site_pkgs}/wxaddons/

	dodoc "${S}"/docs/{CHANGES,PyManual,README,wxPackage,wxPythonManual}.txt

	if use doc; then
		dodir /usr/share/doc/${PF}/docs
		cp -R "${DOC_S}"/docs/* "${D}"usr/share/doc/${PF}/docs/
	fi

	if use examples; then
		dodir /usr/share/doc/${PF}/demo
		dodir /usr/share/doc/${PF}/samples
		cp -R "${DOC_S}"/demo/* "${D}"/usr/share/doc/${PF}/demo/
		cp -R "${DOC_S}"/samples/* "${D}"/usr/share/doc/${PF}/samples/
	fi
}

pkg_postinst() {
	local site_pkgs=/usr/$(get_libdir)/python${PYVER}/site-packages

	python_mod_optimize ${site_pkgs}

	alternatives_auto_makesym \
		"${site_pkgs}/wx.pth" "${site_pkgs}/wx.pth-[0-9].[0-9]"
	alternatives_auto_makesym \
		"${site_pkgs}/wxversion.py" "${site_pkgs}/wxversion.py-[0-9].[0-9]"

	echo
	elog "Gentoo uses the Multi-version method for SLOT'ing."
	elog "Developers, see this site for instructions on using"
	elog "2.6 or 2.8 with your apps:"
	elog "http://wiki.wxpython.org/index.cgi/MultiVersionInstalls"
	elog
	if use doc; then
		elog "To access the general wxWidgets documentation,"
		elog "run /usr/share/doc/${PF}/docs/viewdocs.py"
		elog
		elog "wxPython documentation is available by pointing a browser"
		elog "at /usr/share/doc/${PF}/docs/api/index.html"
		elog
	fi
	if use examples; then
		elog "The demo.py app which contains hundreds of demo modules"
		elog "with documentation and source code has been installed at"
		elog "/usr/share/doc/${PF}/demo/demo.py"
		elog
		elog "Many more example apps and modules can be found in"
		elog "/usr/share/doc/${PF}/samples/"
	fi
	echo
}

pkg_postrm() {
	python_mod_cleanup

	local site_pkgs=/usr/$(get_libdir)/python${PYVER}/site-packages

	alternatives_auto_makesym \
		"${site_pkgs}/wx.pth" "${site_pkgs}/wx.pth-[0-9].[0-9]"
	alternatives_auto_makesym \
		"${site_pkgs}/wxversion.py" "${site_pkgs}/wxversion.py-[0-9].[0-9]"
}
