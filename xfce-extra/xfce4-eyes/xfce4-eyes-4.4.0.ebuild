# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-eyes/xfce4-eyes-4.4.0.ebuild,v 1.19 2007/10/24 01:43:57 angelos Exp $

inherit autotools xfce44

xfce44

DESCRIPTION="panel plugin that adds eyes which watch your every step"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="debug"

DEPEND="dev-util/pkgconfig
	dev-util/intltool"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e "/^AC_INIT/s/eyes_version()/eyes_version/" configure.in
	eautoconf
}

DOCS="AUTHORS ChangeLog NEWS README"

xfce44_goodies_panel_plugin
