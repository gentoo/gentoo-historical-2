# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/superkaramba/superkaramba-4.1.3.ebuild,v 1.2 2008/11/16 08:28:15 vapier Exp $

EAPI="2"

KMNAME=kdeutils
inherit kde4-meta

DESCRIPTION="A tool to create interactive applets for the KDE desktop."
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug htmlhandbook python"

COMMONDEPEND="
	kde-base/qimageblitz
	>=kde-base/libplasma-$PV:$SLOT
	python? ( dev-lang/python )"
DEPEND="${COMMONDEPEND}"
RDEPEND="${COMMONDEPEND}"

PATCHES=("${FILESDIR}/${PN}-as-needed.patch")

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with python PythonLibs)"

	kde4-meta_src_configure
}
