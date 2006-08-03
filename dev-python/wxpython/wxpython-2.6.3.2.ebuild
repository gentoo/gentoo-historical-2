# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/wxpython/wxpython-2.6.3.2.ebuild,v 1.3 2006/08/03 06:00:38 leio Exp $

inherit python wxwidgets eutils multilib

MY_P="${P/wxpython-/wxPython-src-}"
DESCRIPTION="A blending of the wxWindows C++ class library with Python"
HOMEPAGE="http://www.wxpython.org/"
SRC_URI="mirror://sourceforge/wxpython/${MY_P}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="2.6"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="unicode opengl"

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
	cd "${S}" || die "failed to cd to ${S}"
	sed -i "s:cflags.append('-O3'):pass:" config.py || die "sed failed"
	epatch ${FILESDIR}/scripts-multiver-2.6.1.0.diff
}

src_compile() {
	local mypyconf
	export WX_GTK_VER="2.6"
	if use unicode; then
		need-wxwidgets unicode || die "Please re-emerge wxGTK with unicode " \
		"in USE"
	else
		need-wxwidgets gtk2
	fi

	mypyconf="${mypyconf} WX_CONFIG=${WX_CONFIG}"
	use opengl \
		&& 	mypyconf="${mypyconf} BUILD_GLCANVAS=1" \
		|| mypyconf="${mypyconf} BUILD_GLCANVAS=0"

	mypyconf="${mypyconf} WXPORT=gtk2"

	use unicode && mypyconf="${mypyconf} UNICODE=1"

	python setup.py ${mypyconf} build || die "build failed"
}

src_install() {
	python_version
	local mypyconf
	local site_pkgs=/usr/$(get_libdir)/python${PYVER}/site-packages
	dodir ${site_pkgs}

	mypyconf="${mypyconf} WX_CONFIG=${WX_CONFIG}"
	use opengl \
		&& mypyconf="${mypyconf} BUILD_GLCANVAS=1" \
		|| mypyconf="${mypyconf} BUILD_GLCANVAS=0"

	mypyconf="${mypyconf} WXPORT=gtk2"

	use unicode && mypyconf="${mypyconf} UNICODE=1"

	python setup.py ${mypyconf} install --prefix=/usr --root="${D}" || die

	if [ -e "${site_pkgs}/wx.pth" ] && [ "`grep -o 2.4 ${site_pkgs}/wx.pth`" = "2.4" ]; then
		rm "${D}"/${site_pkgs}/wx.pth
		einfo "Keeping 2.4 as system default wxPython"
	else
		if use unicode; then
			wx_name=wx-${PV:0:3}-gtk2-unicode
		else
			wx_name=wx-${PV:0:3}-gtk2-ansi
		fi

		einfo "Setting ${wx_name} as system default wxPython"
		echo ${wx_name} > ${D}/${site_pkgs}/wx.pth || \
			die "Couldn't create wx.pth"

	fi

	cp "${FILESDIR}"/wxpy-config.py "${D}"/${site_pkgs}/

	#Add ${PV} suffix to all /usr/bin/* programs to avoid clobbering SLOT'd
	for filename in "${D}"/usr/bin/* ; do
		mv ${filename} ${filename}-2.6
	done
}

pkg_postinst() {

	einfo "Gentoo now uses the Multi-version method for SLOT'ing"
	einfo "Developers see this site for instructions on using 2.4 or 2.6"
	einfo "with your apps:"
	einfo "http://wiki.wxpython.org/index.cgi/MultiVersionInstalls"
	einfo "2.4 is still the default wxpython for now, but 2.6 apps should"
	einfo "see the above website for selecting the 2.6 lib"
}

