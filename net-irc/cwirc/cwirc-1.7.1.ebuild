# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/cwirc/cwirc-1.7.1.ebuild,v 1.5 2004/06/17 23:22:00 swegener Exp $

inherit eutils

DESCRIPTION="An X-chat plugin for sending and receiving raw morse code over IRC"
HOMEPAGE="http://webperso.easyconnect.fr/om.the/web/cwirc/"
SRC_URI="http://webperso.easyconnect.fr/om.the/web/cwirc/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND="x11-libs/gtk+
	>=net-irc/xchat-2.0.1"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/cwirc-1.7.1-gentoo.patch
}
src_compile() {
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc README README_IAMBIC RELEASE_NOTES Changelog
	cp -R schematics/ ${D}/usr/share/doc/${PF}/schematics/
}
