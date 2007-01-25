# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-smime/claws-mail-smime-0.5.7.ebuild,v 1.2 2007/01/25 08:16:03 opfer Exp $

MY_P="${P#claws-mail-}"

DESCRIPTION="This plugin allows you to handle S/MIME signed and/or encrypted mails."
HOMEPAGE="http://www.claws-mail.org"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=">=mail-client/claws-mail-2.6.1
		>=app-crypt/gpgme-1.1.1"

S="${WORKDIR}/${MY_P}"

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	# kill useless files
	rm -f ${D}/usr/lib*/claws-mail/plugins/*.{a,la}
}
