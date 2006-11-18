# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/gbuffy/gbuffy-0.2.6.ebuild,v 1.4 2006/11/18 02:26:12 compnerd Exp $

inherit eutils

DESCRIPTION="A multi-mailbox biff-like monitor"
HOMEPAGE="http://www.fiction.net/blong/programs/gbuffy/"
SRC_URI="http://www.fiction.net/blong/programs/${PN}/${P}/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"

IUSE="ssl"

DEPEND="x11-libs/libPropList
	media-libs/compface
	>=x11-libs/gtk+-1.1.11
	ssl? ( dev-libs/openssl )"

src_compile() {
	econf --disable-applet || die
	emake || die
}

src_install() {
	einstall || die
	dodoc ChangeLog CHANGES GBuffy LICENSE README ToDo
	doman gbuffy.1
}
