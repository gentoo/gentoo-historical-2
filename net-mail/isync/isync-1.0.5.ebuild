# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/isync/isync-1.0.5.ebuild,v 1.2 2012/06/25 20:25:33 jdhore Exp $

EAPI=4
inherit eutils

DESCRIPTION="MailDir mailbox synchronizer"
HOMEPAGE="http://isync.sourceforge.net/"
SRC_URI="mirror://sourceforge/isync/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="ssl"

DEPEND=">=sys-libs/db-4.2
	ssl? ( >=dev-libs/openssl-0.9.6 )"
RDEPEND="${DEPEND}"

src_configure () {
	econf $(use_with ssl)
}

src_install()
{
	emake DESTDIR="${D}" install
	mv "${D}"/usr/share/doc/${PN} "${D}"/usr/share/doc/${PF} || die
}
