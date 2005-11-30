# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ding/ding-1.4.ebuild,v 1.1 2005/05/05 09:39:50 tove Exp $

DESCRIPTION="Tk based dictionary (German-English) (incl. dictionary itself)"
HOMEPAGE="http://www-user.tu-chemnitz.de/~fri/ding/"
SRC_URI="http://wftp.tu-chemnitz.de/pub/Local/urz/ding/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

RDEPEND=">=dev-lang/tk-8.3
	>=sys-apps/grep-2"

src_install() {
	dobin ding
	insinto /usr/share/dict
	doins de-en.txt
	doman ding.1
	dodoc CHANGES COPYING README

	sed -i "s:Exec=/usr/X11R6/bin/ding:Exec=/usr/bin/ding:g" ding.desktop
	insinto /usr/share/icons ; doins ding.png
	insinto /usr/share/applnk/Utilities ; doins ding.desktop
}
