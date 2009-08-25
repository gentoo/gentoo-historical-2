# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libotr/libotr-3.2.0.ebuild,v 1.7 2009/08/25 10:20:57 fauli Exp $

DESCRIPTION="(OTR) Messaging allows you to have private conversations over instant messaging"
HOMEPAGE="http://www.cypherpunks.ca/otr/"
SRC_URI="http://www.cypherpunks.ca/otr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-libs/libgpg-error
	>=dev-libs/libgcrypt-1.2.0"

src_install() {
	make install DESTDIR="${D}" || die "Install failed"
	dodoc ChangeLog README
}
