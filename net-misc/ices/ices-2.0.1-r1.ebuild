# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ices/ices-2.0.1-r1.ebuild,v 1.2 2007/07/29 08:40:21 drac Exp $

inherit eutils

DESCRIPTION="Icecast OGG streaming client, supports on the fly re-encoding."
HOMEPAGE="http://www.icecast.org/ices.php"
SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="dev-libs/libxml2
	>=media-libs/libshout-2.0
	>=media-libs/libvorbis-1.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	enewgroup ices
	enewuser ices -1 -1 -1 ices
}

src_compile() {
	econf --sysconfdir=/etc/ices2
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS README TODO
	insinto /etc/ices2
	doins conf/*.xml
	dohtml doc/{*.html,*.css}
	newman debian/ices2.1 ices.1
	newinitd "${FILESDIR}"/ices.initd ices
	keepdir /var/log/ices
	fperms 660 /var/log/ices
	fowners ices:ices /var/log/ices
	rm -rf "${D}"/usr/share/ices
}
