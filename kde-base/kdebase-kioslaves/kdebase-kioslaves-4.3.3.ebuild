# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-kioslaves/kdebase-kioslaves-4.3.3.ebuild,v 1.1 2009/11/02 20:51:55 wired Exp $

EAPI="2"

KMNAME="kdebase-runtime"
KMMODULE="kioslave"
inherit kde4-meta

DESCRIPTION="kioslave: the kde VFS framework - kioslave plugins present a filesystem-like view of arbitrary data"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="+bzip2 debug lzma +handbook openexr samba"

# tests hang, last checked for 4.2.96
RESTRICT="test"

DEPEND="
	x11-libs/libXcursor
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	openexr? ( media-libs/openexr )
	samba? ( net-fs/samba )
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kdelibs 'bzip2?,lzma?')
	$(add_kdebase_dep kdesu)
	$(add_kdebase_dep kdialog)
	virtual/eject
	virtual/ssh
"

KMEXTRA="
	kioexec
	kdeeject
"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with bzip2 BZip2)
		$(cmake-utils_use_with lzma LibLZMA)
		$(cmake-utils_use_with openexr OpenEXR)
		$(cmake-utils_use_with samba)
	"

	kde4-meta_src_configure
}

pkg_postinst() {
	echo
	elog "Note that if you upgrade strigi, you have to rebuild this package."
	echo

	kde4-meta_pkg_postinst
}
