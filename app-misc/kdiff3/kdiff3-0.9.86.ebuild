# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/kdiff3/kdiff3-0.9.86.ebuild,v 1.3 2004/08/06 19:17:29 carlo Exp $

inherit kde

DESCRIPTION="KDE-based frontend to diff3"
HOMEPAGE="http://kdiff3.sourceforge.net/"
SRC_URI="mirror://sourceforge/kdiff3/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64 ~ppc ~sparc"
IUSE=""

RDEPEND="sys-apps/diffutils"

need-kde 3