# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmail/kmail-4.2.4.ebuild,v 1.1 2009/06/04 12:51:33 alexxy Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="KMail is the email component of Kontact, the integrated personal information manager of KDE."
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug +handbook +semantic-desktop"

DEPEND="
	>=kde-base/kdelibs-${PV}:${SLOT}[kdeprefix=,semantic-desktop?]
	>=kde-base/libkdepim-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/libkleo-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/libkpgp-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/libksieve-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/mimelib-${PV}:${SLOT}[kdeprefix=]
"
RDEPEND="${DEPEND}
	>=kde-base/kmailcvt-${PV}:${SLOT}[kdeprefix=]
	semantic-desktop? ( >=kde-base/nepomuk-${PV}:${SLOT}[kdeprefix=] )
"

KMEXTRACTONLY="
	kaddressbook/org.kde.KAddressbook.Core.xml
	korganizer/org.kde.Korganizer.Calendar.xml
	libkleo
	libkpgp
	mimelib
"
KMEXTRA="
	plugins/kmail/
"
KMLOADLIBS="libkdepim"

PATCHES=( "${FILESDIR}/${PN}-4.1.72-fix.patch" )

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with semantic-desktop Nepomuk)"

	kde4-meta_src_configure
}
