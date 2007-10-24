# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-clipman/xfce4-clipman-0.8.0.ebuild,v 1.12 2007/10/24 01:15:07 angelos Exp $

inherit xfce44 autotools

DESCRIPTION="Xfce4 panel clipboard manager plugin"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e "/^AC_INIT/s/clipman_version()/clipman_version/" configure.in
	echo "panel-plugin/clipman.desktop.in.in" >>po/POTFILES.skip
	eautoconf
}

xfce44
xfce44_goodies_panel_plugin
