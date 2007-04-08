# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-etpan-privacy/claws-mail-etpan-privacy-0.15.5.ebuild,v 1.2 2007/04/08 01:17:21 josejx Exp $

MY_P="${P#claws-mail-}"
MY_P="${MY_P%[-_]plugin}"

DESCRIPTION="Plugin for sylpheed-claws to sign and verify mails with s/mime or pgp"
HOMEPAGE="http://www.claws-mail.org"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
DEPEND=">=mail-client/claws-mail-2.7.0
		net-libs/libetpan
		dev-libs/openssl"

S="${WORKDIR}/${MY_P}"

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	# kill useless files
	rm -f ${D}/usr/lib*/claws-mail/plugins/*.{a,la}
}
