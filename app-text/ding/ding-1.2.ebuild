# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ding/ding-1.2.ebuild,v 1.9 2004/07/13 20:58:27 agriffis Exp $

DESCRIPTION="Tk based dictionary (German-English) (incl. dictionary itself)"
HOMEPAGE="http://www-user.tu-chemnitz.de/~fri/ding/"
SRC_URI="http://cgi.tu-chemnitz.de/ftp-home/pub/Local/urz/ding/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc"
IUSE=""

RDEPEND=">=dev-lang/tk-8*
	>=sys-apps/grep-2*"

src_install() {
	dobin ding
	insinto /usr/share/dict
	doins ger-eng.txt
	insinto /usr/share/pixmaps
	doins dbook.xpm
	doins mini-dbook.xpm
	doman ding.1
	dodoc CHANGES
	dodoc COPYING
	dodoc README
	dodoc ding.wmconfig
}
