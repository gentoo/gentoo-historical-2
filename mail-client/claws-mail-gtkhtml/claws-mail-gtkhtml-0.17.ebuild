# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-gtkhtml/claws-mail-gtkhtml-0.17.ebuild,v 1.3 2008/05/29 01:51:43 halcy0n Exp $

inherit eutils

MY_P="${PN#claws-mail-}2_viewer-${PV}"

DESCRIPTION="Renders HTML mail using the gtkhtml2 rendering widget."
HOMEPAGE="http://claws.sylpheed.org"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
RDEPEND=">=mail-client/claws-mail-3.2.0
		=gnome-extra/gtkhtml-2*
		net-misc/curl"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
