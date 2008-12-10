# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/tomboy-reminder/tomboy-reminder-0.9.ebuild,v 1.6 2008/12/10 15:52:12 loki_val Exp $

inherit autotools eutils mono

DESCRIPTION="Reminder Plugin for Tomboy"
HOMEPAGE="http://raphael.slinckx.net/blog/projects/tomboy-reminder-plugin/"
SRC_URI="http://raphael.slinckx.net/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-1.0
		 >=app-misc/tomboy-0.5.2"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.19"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-0.9-mcs-to-gmcs.patch
	epatch "${FILESDIR}"/${PN}-0.9-unicode-regex.patch
	eautomake
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS ChangeLog AUTHORS
}
