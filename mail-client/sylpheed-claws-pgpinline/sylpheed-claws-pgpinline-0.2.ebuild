# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/sylpheed-claws-pgpinline/sylpheed-claws-pgpinline-0.2.ebuild,v 1.1 2004/10/17 23:10:01 genone Exp $

MY_P="${P##sylpheed-claws-}"

DESCRIPTION="Plugin for sylpheed-claws to support mails with inline pgp signatures"
HOMEPAGE="http://sylpheed-claws.sourceforge.net"
SRC_URI="http://sylpheed-claws.sourceforge.net/downloads/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND=">=mail-client/sylpheed-claws-0.9.12b-r1
		=app-crypt/gpgme-0.3.14-r1"

S="${WORKDIR}/${MY_P}"

src_compile() {
	export GPGME_CONFIG=${ROOT}/usr/bin/gpgme3-config

	econf || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
}
