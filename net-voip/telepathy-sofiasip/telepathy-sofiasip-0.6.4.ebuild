# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/telepathy-sofiasip/telepathy-sofiasip-0.6.4.ebuild,v 1.1 2010/09/29 18:52:11 pacho Exp $

EAPI="2"

DESCRIPTION="A SIP connection manager for Telepathy based around the Sofia-SIP library."
HOMEPAGE="http://telepathy.freedesktop.org/"
SRC_URI="http://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="debug test"

RDEPEND=">=net-libs/sofia-sip-1.12.10
	>=net-libs/telepathy-glib-0.8.0
	>=dev-libs/glib-2.16
	sys-apps/dbus
	dev-libs/dbus-glib"

DEPEND="${RDEPEND}
	dev-libs/libxslt
	dev-lang/python
	test? ( dev-python/twisted )"

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die
}
