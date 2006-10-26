# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/acpitool/acpitool-0.2.5.ebuild,v 1.1 2006/10/26 19:16:37 peper Exp $

DESCRIPTION="A small command line application, intended to be a replacement for the apm tool"
HOMEPAGE="http://freeunix.dyndns.org:8088/site2/acpitool.shtml"
SRC_URI="http://freeunix.dyndns.org:8088/ftp_site/pub/unix/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""
DEPEND=""

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog README TODO
}
