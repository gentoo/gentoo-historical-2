# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/checkpassword-pam/checkpassword-pam-0.96.ebuild,v 1.1 2003/07/16 19:56:21 raker Exp $

IUSE=""

DESCRIPTION="checkpassword-compatible authentication program w/pam support"
HOMEPAGE="http://checkpasswd-pam.sourceforge.net/"
SRC_URI="http://switch.dl.sourceforge.net/sourceforge/checkpasswd-pam/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=sys-libs/pam-0.75
	virtual/glibc"

S=${WORKDIR}/${P}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS NEWS README
}
