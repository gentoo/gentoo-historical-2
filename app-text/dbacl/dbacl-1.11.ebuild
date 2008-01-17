# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dbacl/dbacl-1.11.ebuild,v 1.3 2008/01/17 20:33:04 grobian Exp $

inherit eutils

DESCRIPTION="digramic Bayesian text classifier"
HOMEPAGE="http://www.lbreyer.com/gpl.html"
SRC_URI="http://www.lbreyer.com/gpl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~s390 ~x86"
IUSE=""

DEPEND=""

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README AUTHORS NEWS ChangeLog
}
