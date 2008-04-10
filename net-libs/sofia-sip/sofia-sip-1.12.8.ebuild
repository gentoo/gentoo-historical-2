# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/sofia-sip/sofia-sip-1.12.8.ebuild,v 1.1 2008/04/10 23:38:34 tester Exp $

DESCRIPTION="RFC3261 compliant SIP User-Agent library"
HOMEPAGE="http://sofia-sip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

RDEPEND="dev-libs/glib
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"

src_compile() {
	econf $(use_with ssl openssl) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ChangeLog COPYRIGHTS README TODO
}
