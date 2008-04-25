# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-quicklauncher/xfce4-quicklauncher-1.9.4.ebuild,v 1.11 2008/04/25 16:07:23 drac Exp $

inherit autotools xfce44

xfce44
xfce44_goodies_panel_plugin

DESCRIPTION="Xfce4 panel quicklauncher plugin"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"

DEPEND="xfce-extra/xfce4-dev-tools
	dev-util/intltool"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e "/^AC_INIT/s/quicklauncher_version()/quicklauncher_version/" configure.ac
	intltoolize --force --copy --automake || die "intltoolize failed."
	AT_M4DIR=/usr/share/xfce4/dev-tools/m4macros eautoreconf
}

DOCS="AUTHORS NEWS README TODO"
