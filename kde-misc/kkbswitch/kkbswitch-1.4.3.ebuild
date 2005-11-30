# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kkbswitch/kkbswitch-1.4.3.ebuild,v 1.1.1.1 2005/11/30 09:57:12 chriswhite Exp $

inherit kde

DESCRIPTION="Keyboard layout indicator for KDE"
HOMEPAGE="http://kkbswitch.sourceforge.net/"
SRC_URI="mirror://sourceforge/kkbswitch/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

need-kde 3.1

src_install() {
	kde_src_install

	insinto /usr/share/pixmaps
	doins kkbswitch.xpm
}
