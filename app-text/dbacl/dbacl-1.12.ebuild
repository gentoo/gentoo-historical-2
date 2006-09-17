# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dbacl/dbacl-1.12.ebuild,v 1.2 2006/09/17 19:23:48 steev Exp $

inherit eutils

DESCRIPTION="digramic Bayesian text classifier"
HOMEPAGE="http://www.lbreyer.com/gpl.html"
SRC_URI="http://www.lbreyer.com/gpl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc-macos ~s390 ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README AUTHORS NEWS ChangeLog
}
