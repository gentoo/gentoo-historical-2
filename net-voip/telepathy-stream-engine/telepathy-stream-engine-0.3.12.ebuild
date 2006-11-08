# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/telepathy-stream-engine/telepathy-stream-engine-0.3.12.ebuild,v 1.1 2006/11/08 19:31:03 peper Exp $

DESCRIPTION="A Telepathy client that handles channels of type 'StreamedMedia'"
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/stream-engine/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/glib-2.4
	dev-libs/libxml2
	>=media-libs/farsight-0.1.8
	=media-libs/gst-plugins-base-0.10*
	>=net-libs/libtelepathy-0.0.33
	>=sys-apps/dbus-0.60"
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "emake failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	elog "You don't need to start stream-engine manualy any more."
	elog "dbus will take care of that."
}
