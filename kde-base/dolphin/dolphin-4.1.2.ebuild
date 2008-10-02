# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dolphin/dolphin-4.1.2.ebuild,v 1.1 2008/10/02 06:26:39 jmbsvicetto Exp $

EAPI="2"

KMNAME=kdebase
KMMODULE=apps/${PN}
inherit kde4-meta

DESCRIPTION="A KDE filemanager focusing on usability"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook +semantic-desktop"

DEPEND=">=kde-base/libkonq-${PV}:${SLOT}
	kde-base/kdelibs:${SLOT}[semantic-desktop=]
	semantic-desktop? ( >=kde-base/nepomuk-${PV}:${SLOT}
						>=dev-libs/soprano-2.0.7 )"
RDEPEND="${DEPEND}"

KMEXTRA="apps/doc/${PN}"
KMLOADLIBS="libkonq"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)"
	kde4-meta_src_configure
}
