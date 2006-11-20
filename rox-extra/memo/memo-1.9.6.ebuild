# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-extra/memo/memo-1.9.6.ebuild,v 1.2 2006/11/20 18:25:01 opfer Exp $

ROX_LIB_VER=1.9.8
inherit rox

MY_PN="Memo"
DESCRIPTION="Memo - Memo is a simple alarm clock and clock applet for the ROX Desktop."
HOMEPAGE="http://rox.sourceforge.net/phpwiki/index.php/Memo"
SRC_URI="mirror://sourceforge/rox/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

APPNAME=${MY_PN}
