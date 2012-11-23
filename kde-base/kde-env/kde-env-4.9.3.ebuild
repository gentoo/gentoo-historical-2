# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-env/kde-env-4.9.3.ebuild,v 1.4 2012/11/23 18:39:39 ago Exp $

EAPI=4

CMAKE_REQUIRED="never"
KDE_REQUIRED="never"
inherit kde4-base

DESCRIPTION="Environment setting required for all KDE4 apps to run."
SRC_URI=""
ESVN_REPO_URI=""

KEYWORDS="amd64 ~arm x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
IUSE="aqua"

add_blocker kdelibs 4.6.80

S=${WORKDIR}

src_unpack() {
	:
}

src_prepare() {
	:
}

src_install() {
	# number goes down with version
	cat <<-EOF > 43kdepaths
CONFIG_PROTECT="/usr/share/config"
#KDE_IS_PRELINKED=1
EOF
	doenvd 43kdepaths

	# Properly place xinitrc.d file that exports XDG_MENU_PREFIX to env
	cat <<EOF > 11-xdg-menu-kde-4
#!/bin/sh

if [ -z \${XDG_MENU_PREFIX} ] && [ "\${DESKTOP_SESSION}" = "KDE-4" ]; then
	export XDG_MENU_PREFIX="kde-4-"
fi
EOF
	exeinto /etc/X11/xinit/xinitrc.d/
	doexe 11-xdg-menu-kde-4
}

pkg_preinst() {
	:
}

src_test() {
	:
}
