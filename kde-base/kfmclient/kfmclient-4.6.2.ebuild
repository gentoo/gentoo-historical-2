# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kfmclient/kfmclient-4.6.2.ebuild,v 1.5 2011/06/14 23:28:32 abcd Exp $

EAPI=3

KMNAME="kdebase-apps"
KMMODULE="konqueror/client"
inherit kde4-meta

DESCRIPTION="KDE tool for opening URLs from the command line"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

# Moved from kde-base/konqueror in 4.3.65-r1
add_blocker konqueror 4.3.65

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
