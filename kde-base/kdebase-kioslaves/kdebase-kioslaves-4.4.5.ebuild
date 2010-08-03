# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-kioslaves/kdebase-kioslaves-4.4.5.ebuild,v 1.2 2010/08/03 07:42:29 hwoarang Exp $

EAPI="3"

KMNAME="kdebase-runtime"
KMMODULE="kioslave"
inherit kde4-meta

KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
DESCRIPTION="kioslave: the kde VFS framework - kioslave plugins present a filesystem-like view of arbitrary data"
IUSE="+bzip2 exif debug lzma +handbook openexr samba +sftp"

# tests hang, last checked for 4.2.96
RESTRICT="test"

DEPEND="
	!aqua? ( x11-libs/libXcursor )
	bzip2? ( app-arch/bzip2 )
	exif? ( media-gfx/exiv2 )
	lzma? ( app-arch/xz-utils )
	openexr? ( media-libs/openexr )
	samba? (
		|| (
			=net-fs/samba-3.0*
			>=net-fs/samba-3.4.6[smbclient]
		)
	)
	sftp? ( >=net-libs/libssh-0.4.0[sftp] )
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kdelibs 'bzip2?,lzma?')
	$(add_kdebase_dep kdialog)
	virtual/ssh
	!aqua? ( !kernel_SunOS? ( virtual/eject ) )
"

KMEXTRA="
	kioexec
	kdeeject
"

src_configure() {
	mycmakeargs=(
		-DWITH_SLP=OFF
		$(cmake-utils_use_with bzip2 BZip2)
		$(cmake-utils_use_with exif Exiv2)
		$(cmake-utils_use_with lzma LibLZMA)
		$(cmake-utils_use_with openexr OpenEXR)
		$(cmake-utils_use_with samba)
		$(cmake-utils_use_with sftp LibSSH)
	)
	kde4-meta_src_configure
}

pkg_postinst() {
	echo
	elog "Note that if you upgrade strigi, you have to rebuild this package."
	echo

	kde4-meta_pkg_postinst
}
