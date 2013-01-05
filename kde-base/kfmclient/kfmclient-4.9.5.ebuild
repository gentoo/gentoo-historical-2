# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kfmclient/kfmclient-4.9.5.ebuild,v 1.1 2013/01/05 20:19:02 creffett Exp $

EAPI=4

KMNAME="kde-baseapps"
KMMODULE="konqueror/client"
inherit kde4-meta

DESCRIPTION="KDE tool for opening URLs from the command line"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

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
