# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/gml/gml-0.5.ebuild,v 1.2 2005/01/03 23:53:01 ticho Exp $

inherit eutils

DESCRIPTION="Google GMail Loader"
HOMEPAGE="http://www.marklyon.org/gmail"
SRC_URI="http://www.marklyon.org/gmail/gmlw.tar"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND="dev-python/pmw
	app-text/dos2unix"
S=${WORKDIR}/

src_install() {
	dos2unix -o gmlw.py
	dobin gmlw.py || die
	dodoc README COPYING || die
}
