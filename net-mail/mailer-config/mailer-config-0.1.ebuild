# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mailer-config/mailer-config-0.1.ebuild,v 1.4 2005/04/25 19:44:04 slarti Exp $

DESCRIPTION="Utility to switch between mailers using mailwrapper"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~alpha ~hppa"
IUSE=""

DEPEND=""

src_install() {
	dobin  mailer-config
	dodoc README

	insinto /etc/mail/
	newins "${FILESDIR}/mailer.conf" default.mailer
}

pkg_postinst() {
	einfo " "
	einfo "Because /etc/mail/mailer.conf is now handled for you, it will"
	einfo "save time if you add:"
	einfo "    CONFIG_PROTECT_MASK=\"/etc/mail/mailer.conf\""
	einfo "to your /etc/make.conf file."
	einfo " "
	einfo "With this, when a new profile is installed, it will be switched to"
	einfo "automatically, and you will not be prompted to etc-update"
	einfo "mailer.conf manually. Instead, you should always use mailer-config."
	einfo " "
}
