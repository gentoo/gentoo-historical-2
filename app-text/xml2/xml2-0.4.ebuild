# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xml2/xml2-0.4.ebuild,v 1.2 2010/01/02 11:45:51 fauli Exp $

inherit autotools eutils

DESCRIPTION="These tools are used to convert XML and HTML to and from a line-oriented format."
HOMEPAGE="http://dan.egnor.name/xml2"
SRC_URI="http://download.ofb.net/gale/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-libxml2.patch
	eautoreconf
}

src_compile() {
	econf --disable-dependency-tracking
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
}
