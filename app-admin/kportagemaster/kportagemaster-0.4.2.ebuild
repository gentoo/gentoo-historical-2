# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-admin/kportagemaster/kportagemaster-0.4.2.ebuild,v 1.1 2002/08/08 19:19:34 danarmak Exp $
inherit kde-base

need-kde 3

DESCRIPTION="A graphical frontend for emerge"
SRC_URI="http://user.cs.tu-berlin.de/~mehnert/${P}.tar.bz2"
HOMEPAGE="http://user.cs.tu-berlin.de/~mehnert/"

LICENSE="GPL-2"
#not heard anything about running on other platforms
KEYWORDS="x86"
SLOT="0"

RDEPEND="$RDEPEND >=kde-base/kdebase-3
	>=sys-apps/portage-2.0.18"
