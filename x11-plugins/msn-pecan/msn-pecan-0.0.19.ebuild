# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/msn-pecan/msn-pecan-0.0.19.ebuild,v 1.1 2009/07/19 19:54:21 voyageur Exp $

inherit toolchain-funcs multilib

DESCRIPTION="Alternative MSN protocol plugin for libpurple"
HOMEPAGE="http://code.google.com/p/msn-pecan/"

SRC_URI="http://msn-pecan.googlecode.com/files/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-im/pidgin"
DEPEND="dev-util/pkgconfig
	${RDEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc COPYRIGHT ChangeLog README TODO || die "dodoc failed"
}

pkg_postinst() {
	elog "Select the 'WLM' protocol to use this plugin"
	einfo
	elog "For more information (how to change personal message, add"
	elog "missing emoticons, ...), please read:"
	elog "http://code.google.com/p/msn-pecan/wiki/FAQ"
}
