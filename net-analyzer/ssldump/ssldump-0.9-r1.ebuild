# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ssldump/ssldump-0.9-r1.ebuild,v 1.2 2008/10/25 13:35:46 maekke Exp $

inherit eutils autotools

MY_P=${PN}-0.9b3
DESCRIPTION="A Tool for network monitoring and data acquisition"
SRC_URI="http://www.rtfm.com/ssldump/${MY_P}.tar.gz"
HOMEPAGE="http://www.rtfm.com/ssldump/"
IUSE="ssl"

SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
LICENSE="GPL-2"

DEPEND="net-libs/libpcap
	ssl? ( >=dev-libs/openssl-0.6.9 )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A} ; cd ${S}

	epatch "${FILESDIR}/${P}"-libpcap-header.patch
	epatch "${FILESDIR}/${P}"-configure-dylib.patch
	epatch "${FILESDIR}/${P}"-openssl-0.9.8.compile-fix.patch
	epatch "${FILESDIR}/${P}"-DLT_LINUX_SLL.patch
	eautoreconf # fixes compiler detection
}

src_compile() {
	econf $(use_with ssl crypto)
	emake || die
}

src_install() {
	into /usr
	dosbin ssldump || die
	doman ssldump.1 || die
	dodoc COPYRIGHT CREDITS README FILES VERSION INSTALL ChangeLog
}
