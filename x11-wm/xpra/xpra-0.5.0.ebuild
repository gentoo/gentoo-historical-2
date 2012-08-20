# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/xpra/xpra-0.5.0.ebuild,v 1.1 2012/08/20 21:18:40 xmw Exp $

EAPI=3

PYTHON_DEPEND="*"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.*"
SUPPORT_PYTHON_ABIS="1"
inherit distutils eutils

DESCRIPTION="X Persistent Remote Apps (xpra) and Partitioning WM (parti) based on wimpiggy"
HOMEPAGE="http://xpra.org/"
SRC_URI="http://xpra.org/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="ffmpeg jpeg libnotify parti png server ssh x264"

COMMON_DEPEND="dev-python/pygtk:2
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	ffmpeg? (
		virtual/ffmpeg
		x264? ( media-libs/x264 )
	)
	server? ( x11-libs/libXtst )
	!x11-wm/parti"

RDEPEND="${COMMON_DEPEND}
	x11-apps/xmodmap
	parti? ( dev-python/ipython
		 dev-python/dbus-python )
	libnotify? ( dev-python/dbus-python )
	jpeg? ( dev-python/imaging )
	png? ( dev-python/imaging )
	ssh? ( virtual/ssh )
	server? ( x11-base/xorg-server[xvfb,-minimal] )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	>=dev-python/cython-0.16"

src_prepare() {
	use server || epatch disable-posix-server.patch
	if use ffmpeg ; then
		use x264 || epatch disable-x264.patch
	else
		epatch disable-vpx.patch disable-x264.patch
	fi

	$(PYTHON -2) make_constants_pxi.py wimpiggy/lowlevel/constants.txt wimpiggy/lowlevel/constants.pxi || die

	#python_copy_sources
	#
	#patching() {
	#    [[ "${PYTHON_ABI}" == 2.* ]] && return
	#	2to3 --no-diffs -x all -f except -w -n .
	#}
	#python_execute_function --action-message 'Applying patches with $(python_get_implementation) $(python_get_version)' -s patching
}

src_install() {
	distutils_src_install
	rm -vf "${ED}"usr/share/{parti,wimpiggy,xpra}/{README*,COPYING} || die
}
