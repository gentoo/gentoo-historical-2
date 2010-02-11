# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-archive/claws-mail-archive-0.6.6.ebuild,v 1.2 2010/02/11 12:52:44 fauli Exp $

inherit eutils

MY_P="${P#claws-mail-}"

DESCRIPTION="Plugin for Claws to add archiving features"
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""
RDEPEND=">=mail-client/claws-mail-3.7.4
	app-arch/libarchive
	>=net-misc/curl-7.9.7"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
