# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-fancy/claws-mail-fancy-0.9.9.ebuild,v 1.3 2010/03/11 20:42:54 maekke Exp $

MY_P="${PN#claws-mail-}-${PV}"

DESCRIPTION="Plugin to display HTML with Webkit"
HOMEPAGE="http://www.claws-mail.org/"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND=">=mail-client/claws-mail-3.7.4"
DEPEND="${RDEPEND}
	>=net-libs/webkit-gtk-1.0
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
