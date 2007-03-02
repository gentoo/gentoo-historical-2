# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-icon-theme/xfce4-icon-theme-4.4.0.ebuild,v 1.4 2007/03/02 22:31:01 welp Exp $

inherit xfce44

xfce44

DESCRIPTION="Icon theme"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
RESTRICT="binchecks strip"

RDEPEND="x11-themes/hicolor-icon-theme"
DEPEND="dev-util/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README TODO"

xfce44_core_package
