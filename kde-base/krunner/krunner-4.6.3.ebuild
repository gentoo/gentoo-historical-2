# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krunner/krunner-4.6.3.ebuild,v 1.1 2011/05/07 10:47:59 scarabeus Exp $

EAPI=4

KMNAME="kdebase-workspace"
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="KDE Command Runner"
IUSE="debug"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

COMMONDEPEND="
	$(add_kdebase_dep kcheckpass)
	$(add_kdebase_dep kephal)
	$(add_kdebase_dep ksmserver)
	$(add_kdebase_dep ksysguard)
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep libplasmagenericshell)
	!aqua? (
		x11-libs/libXcursor
		x11-libs/libXScrnSaver
	)
"
DEPEND="${COMMONDEPEND}
	!aqua? (
		x11-libs/libXcursor
		x11-proto/scrnsaverproto
	)
"
RDEPEND="${COMMONDEPEND}"

PATCHES=( "${FILESDIR}/${PN}"-4.6.2-noxf86misc.patch )

KMEXTRACTONLY="
	libs/kdm/
	libs/kephal/
	libs/ksysguard/
	libs/kworkspace/
	libs/plasmagenericshell/
	kcheckpass/
	ksmserver/org.kde.KSMServerInterface.xml
	ksysguard/
	plasma/screensaver/shell/org.kde.plasma-overlay.App.xml
"

KMLOADLIBS="libkworkspace"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with opengl OpenGL)
	)

	kde4-meta_src_configure
}
