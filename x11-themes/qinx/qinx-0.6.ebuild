# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/qinx/qinx-0.6.ebuild,v 1.4 2004/04/27 20:45:38 pvdabeel Exp $

inherit kde

need-kde 3

DESCRIPTION="Qinx, a KDE style inspired by QNX Photon microGUI"
SRC_URI="http://www.usermode.org/code/${P}.tar.gz"
HOMEPAGE="http://www.usermode.org/code.html"
LICENSE="as-is"

KEYWORDS="x86 ~alpha ppc ~sparc"

newdepend ">=kde-base/kdebase-3.0"
