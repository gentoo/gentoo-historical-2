# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/wxpython/wxpython-2.6.4.0-r1.ebuild,v 1.2 2007/12/04 15:58:27 dirtyepic Exp $

WX_GTK_VER="2.6"

inherit alternatives eutils multilib python wxwidgets

MY_P="${P/wxpython-/wxPython-src-}"
DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="http://www.wxpython.org/"
SRC_URI="mirror://sourceforge/wxpython/${MY_P}.tar.bz2"

LICENSE="wxWinLL-3"
SLOT="2.6"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="opengl unicode"

RDEPEND=">=dev-lang/python-2.1
	>=x11-libs/wxGTK-${PV}
	>=x11-libs/gtk+-2.0
	>=x11-libs/pango-1.2
	>=dev-libs/glib-2.0
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	>=sys-libs/zlib-1.1.4
	opengl? ( >=dev-python/pyopengl-2.0.0.44 )
	!<dev-python/wxpython-2.4.2.4-r1"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}/wxPython/"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i "s:cflags.append('-O3'):pass:" config.py || die "sed failed"
	epatch "${FILESDIR}"/scripts-multiver-2.6.1.0.diff
}

src_compile() {
	local mypyconf

	if use unicode; then
		need-wxwidgets unicode
	else
		need-wxwidgets ansi
	fi

	use opengl && check_wxuse opengl

	mypyconf="${mypyconf} WX_CONFIG=${WX_CONFIG}"
	use opengl \
		&& mypyconf="${mypyconf} BUILD_GLCANVAS=1" \
		|| mypyconf="${mypyconf} BUILD_GLCANVAS=0"

	use unicode \
		&& mypyconf="${mypyconf} UNICODE=1" \
		|| mypyconf="${mypyconf} UNICODE=0"

	mypyconf="${mypyconf} WXPORT=gtk2"

	python setup.py ${mypyconf} build || die "setup.py build failed"
}

src_install() {
	local mypyconf
	python_version
	local site_pkgs=/usr/$(get_libdir)/python${PYVER}/site-packages

	dodir ${site_pkgs}

	mypyconf="${mypyconf} WX_CONFIG=${WX_CONFIG}"
	use opengl \
		&& mypyconf="${mypyconf} BUILD_GLCANVAS=1" \
		|| mypyconf="${mypyconf} BUILD_GLCANVAS=0"

	use unicode \
		&& mypyconf="${mypyconf} UNICODE=1" \
		|| mypyconf="${mypyconf} UNICODE=0"

	mypyconf="${mypyconf} WXPORT=gtk2"

	python setup.py ${mypyconf} install --prefix=/usr --root="${D}" \
		|| die "setup.py install failed"

	# Collision protection.
	for file in \
		"${D}"/usr/bin/* \
		"${D}"/${site_pkgs}/wx{version.*,.pth,addons}; do
			mv "${file}" "${file}-${SLOT}"
	done
}

pkg_postinst() {
	python_mod_optimize

	local site_pkgs=/usr/$(get_libdir)/python${PYVER}/site-packages

	alternatives_auto_makesym \
		"${site_pkgs}/wx.pth" "${site_pkgs}/wx.pth-[0-9].[0-9]"
	alternatives_auto_makesym \
		"${site_pkgs}/wxversion.py" "${site_pkgs}/wxversion.py-[0-9].[0-9]"

	echo
	elog "Gentoo uses the Multi-version method for SLOT'ing."
	elog "Developers see this site for instructions on using 2.6 or 2.8"
	elog "with your apps:"
	elog "http://wiki.wxpython.org/index.cgi/MultiVersionInstalls"
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
