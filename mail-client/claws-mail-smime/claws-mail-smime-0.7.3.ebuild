# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-smime/claws-mail-smime-0.7.3.ebuild,v 1.3 2008/05/29 02:14:22 halcy0n Exp $

MY_P="${P#claws-mail-}"

DESCRIPTION="This plugin allows you to handle S/MIME signed and/or encrypted mails."
HOMEPAGE="http://www.claws-mail.org"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""
RDEPEND=">=mail-client/claws-mail-3.1.0
		>=app-crypt/gpgme-1.1.1"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
