# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/dcoppython/dcoppython-3.3.1.ebuild,v 1.2 2004/12/10 20:22:02 danarmak Exp $

KMNAME=kdebindings
KM_MAKEFILESREV=1
inherit kde-meta

DESCRIPTION="KDE: Python bindings for DCOP"
KEYWORDS="~x86"
IUSE=""
DEPEND="virtual/python"
PATCHES="$FILESDIR/no-gtk-glib-check.diff"


