# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkworkspace/libkworkspace-4.7.4-r2.ebuild,v 1.1 2012/02/03 15:50:03 johu Exp $

EAPI=4

KMNAME="kde-workspace"
KMMODULE="libs/kworkspace"
inherit kde4-meta

DESCRIPTION="A library for KDE desktop applications"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

KMEXTRACTONLY="
	ksmserver/org.kde.KSMServerInterface.xml
	kwin/org.kde.KWin.xml
"

KMSAVELIBS="true"

DEPEND="
	x11-libs/libxkbfile
	x11-libs/libXcomposite
"
RDEPEND=${DEPEND}

PATCHES=(
	"${FILESDIR}/${PN}-4.8.0-pam-optional.patch"
)

src_prepare() {
	sed -i -e 's/install( FILES kdisplaymanager.h/install( FILES kdisplaymanager.h screenpreviewwidget.h/' \
		libs/kworkspace/CMakeLists.txt || die "failed to provide screenpreviewwidget.h"

	kde4-meta_src_prepare
}
