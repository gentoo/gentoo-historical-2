# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-base/pager/pager-1.1.ebuild,v 1.2 2006/11/27 19:12:09 lack Exp $

ROX_CLIB_VER=2.1.7
inherit rox eutils

DESCRIPTION="Pager - A pager applet for ROX-Filer"
HOMEPAGE="http://rox.sourceforge.net/"
SRC_URI="mirror://sourceforge/rox/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/libwnck-2.4.0"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.20"

APPNAME=Pager

