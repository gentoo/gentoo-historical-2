# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/korundum/korundum-3.3.1.ebuild,v 1.2 2004/12/10 20:22:02 danarmak Exp $

KMNAME=kdebindings
KMCOPYLIB="libsmokeqt smoke/qt libsmokekde smoke/kde"
KMCOMPILEONLY="qtruby"
KM_MAKEFILES_REV=1
inherit kde-meta

DESCRIPTION="KDE ruby bindings"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=virtual/ruby-1.8 ~kde-base/qtruby-$PV ~kde-base/smoke-$PV"
PATCHES="$FILESDIR/no-gtk-glib-check.diff"


