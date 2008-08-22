# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-extra/memo/memo-2.1.ebuild,v 1.1 2008/08/22 14:02:32 lack Exp $

ROX_LIB_VER=1.9.8
inherit rox

MY_PN="Memo"
DESCRIPTION="Memo is a simple alarm clock and clock applet for the ROX Desktop."
HOMEPAGE="http://rox.sourceforge.net/phpwiki/index.php/Memo"
SRC_URI="mirror://sourceforge/rox/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="libnotify"

RDEPEND="libnotify? (
	>=dev-python/dbus-python-0.71
	x11-libs/libnotify )"

APPNAME=${MY_PN}
APPCATEGORY="Utility;Clock"
