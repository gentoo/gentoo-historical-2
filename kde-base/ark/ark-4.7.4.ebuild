# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ark/ark-4.7.4.ebuild,v 1.4 2012/02/18 14:44:08 nixnut Exp $

EAPI=4

KDE_HANDBOOK="optional"
KDE_SCM="git"
if [[ ${PV} == *9999 ]]; then
	kde_eclass="kde4-base"
else
	KMNAME="kdeutils"
	kde_eclass="kde4-meta"
fi
inherit ${kde_eclass}

DESCRIPTION="KDE Archiving tool"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+archive +bzip2 debug lzma"

DEPEND="
	$(add_kdebase_dep libkonq)
	sys-libs/zlib
	archive? ( >=app-arch/libarchive-2.6.1[bzip2?,lzma?,zlib] )
	lzma? ( app-arch/xz-utils )
"
RDEPEND="${DEPEND}"

RESTRICT=test
# tests hang, no bug yet

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with archive LibArchive)
		$(cmake-utils_use_with bzip2 BZip2)
		$(cmake-utils_use_with lzma LibLZMA)
	)
	${kde_eclass}_src_configure
}

pkg_postinst() {
	${kde_eclass}_pkg_postinst
	elog "For creating rar archives, install app-arch/rar"
}
