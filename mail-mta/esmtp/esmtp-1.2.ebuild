# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-mta/esmtp/esmtp-1.2.ebuild,v 1.1 2010/06/09 18:56:16 patrick Exp $

DESCRIPTION="esmtp is a user configurable relay-only Mail Transfer Agent (MTA) with a sendmail compatible syntax"
HOMEPAGE="http://esmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND="net-libs/libesmtp
	dev-libs/openssl"
RDEPEND="${DEPEND}
		!net-mail/mailwrapper
		!virtual/mta"

PROVIDE="virtual/mta"

src_install() {
	emake DESTDIR="${D}" install || die "einstall failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die
}
