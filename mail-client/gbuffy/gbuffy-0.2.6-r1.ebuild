# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/gbuffy/gbuffy-0.2.6-r1.ebuild,v 1.4 2011/06/14 11:30:59 eras Exp $

EAPI=1

inherit eutils toolchain-funcs

DESCRIPTION="A multi-mailbox biff-like monitor"
HOMEPAGE="http://www.fiction.net/blong/programs/gbuffy/"
SRC_URI="http://www.fiction.net/blong/programs/${PN}/${P}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="ssl"

DEPEND="x11-libs/libPropList
	media-libs/compface
	>=x11-libs/gtk+-1.1.11:1
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/gbuffy-1.patch
	epatch "${FILESDIR}"/gbuffy-search-3.patch
	epatch "${FILESDIR}"/gbuffy-ldflags.patch
}

src_compile() {
	econf --disable-applet || die
	emake CC=$(tc-getCC) || die
}

src_install() {
	einstall || die
	dodoc ChangeLog CHANGES GBuffy README ToDo
	doman gbuffy.1
}
