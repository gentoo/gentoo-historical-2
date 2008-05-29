# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-notification/claws-mail-notification-0.15.ebuild,v 1.2 2008/05/29 02:06:33 halcy0n Exp $

MY_P="${PN#claws-mail-}_plugin-${PV}"

DESCRIPTION="Plugin providing various ways to notify user of new and unread mail."
HOMEPAGE="http://www.claws-mail.org"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libnotify"
RDEPEND=">=mail-client/claws-mail-3.3.0
		>=x11-libs/gtk+-2.10
		libnotify? ( x11-libs/libnotify )"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf $(use_enable libnotify) || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
