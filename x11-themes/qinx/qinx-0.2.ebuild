# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/qinx/qinx-0.2.ebuild,v 1.9 2004/06/24 23:37:08 agriffis Exp $

inherit kde

need-kde 3

DESCRIPTION="Qinx, a KDE style inspired by QNX Photon microGUI"
SRC_URI="http://www.usermode.org/code/qinx-0.2.tar.gz"
HOMEPAGE="http://www.usermode.org/code.html"
LICENSE="as-is"

KEYWORDS="x86 alpha -ppc"

newdepend ">=kde-base/kdebase-3.0"
