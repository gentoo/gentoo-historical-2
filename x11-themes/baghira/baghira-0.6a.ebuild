# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/baghira/baghira-0.6a.ebuild,v 1.2 2005/01/15 00:21:19 danarmak Exp $

inherit kde

DESCRIPTION="Baghira - an OS-X like style for KDE"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=8692"
SRC_URI="mirror://sourceforge/baghira/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc ~alpha"
IUSE=""

DEPEND="|| ( kde-base/kdebase-meta >=kde-base/kdebase-3.3 )"
need-kde 3.3
