# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/pwcrypt/pwcrypt-1.2.2.ebuild,v 1.5 2004/06/25 23:02:42 vapier Exp $

DESCRIPTION="An improved version of cli-crypt (encrypts data sent to it from the cli)"
HOMEPAGE="http://xjack.org/pwcrypt"
SRC_URI="http://xjack.org/pwcrypt/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/libc"

src_install() {
	dobin src/pwcrypt || die
	dodoc [A-Z][A-Z]*
}
