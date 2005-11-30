# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/posh/posh-0.3.18.ebuild,v 1.1.1.1 2005/11/30 10:00:24 chriswhite Exp $

DESCRIPTION="stripped-down version of pdksh"
HOMEPAGE="http://packages.debian.org/posh/"
SRC_URI="mirror://debian/pool/main/p/posh/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=""

src_install() {
	emake DESTDIR=${D} bindir=/bin install || die
}
