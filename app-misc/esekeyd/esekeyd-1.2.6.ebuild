# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/esekeyd/esekeyd-1.2.6.ebuild,v 1.1 2010/05/14 17:42:47 ssuominen Exp $

EAPI=2

DESCRIPTION="Multimedia key daemon that uses the Linux event interface"
HOMEPAGE="http://freshmeat.net/projects/esekeyd/"
SRC_URI="http://www.burghardt.pl/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog examples/example.conf NEWS README TODO || die
}
