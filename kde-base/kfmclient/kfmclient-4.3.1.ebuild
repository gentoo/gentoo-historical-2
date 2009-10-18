# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kfmclient/kfmclient-4.3.1.ebuild,v 1.5 2009/10/18 15:53:28 maekke Exp $

EAPI="2"

KMNAME="kdebase-apps"
KMMODULE="konqueror/client"
inherit kde4-meta

DESCRIPTION="KDE tool for opening URLs from the command line"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 x86"
IUSE="debug"

# Moved from kde-base/konqueror in 4.3.0-r2, 4.3.65-r1, and 9999-r1, so ugly blockers...
RDEPEND="
	!kdeprefix? (
		!kde-base/konqueror:kde-4[-kdeprefix]
		!kde-base/konqueror:4.1[-kdeprefix]
		!kde-base/konqueror:4.2[-kdeprefix]
		!<=kde-base/konqueror-4.3.0-r1:4.3[-kdeprefix]
		!<=kde-base/konqueror-4.3.65:4.4[-kdeprefix]
		!<=kde-base/konqueror-9999:live[-kdeprefix]
	)
	kdeprefix? ( !<=kde-base/konqueror-4.3.0-r1:4.3[kdeprefix] )
	>=kde-base/kioclient-${PV}:${SLOT}[kdeprefix=]
"

KMEXTRACTONLY="
	konqueror/kfmclient.desktop
	konqueror/kfmclient_dir.desktop
	konqueror/kfmclient_html.desktop
	konqueror/kfmclient_war.desktop
	konqueror/src/org.kde.Konqueror.Main.xml
	konqueror/src/org.kde.Konqueror.MainWindow.xml
"

src_prepare() {
	kde4-meta_src_prepare

	# Do not install non-kfmclient *.desktop files
	sed -e "/konqbrowser\.desktop/d" \
		-e "/konqueror\.desktop/s/^/#DONOTWANT/" \
		-e "/install(FILES profile/s/^/#DONOTWANT/" \
		-i konqueror/CMakeLists.txt \
		|| die "Failed to omit .desktop files"
}
