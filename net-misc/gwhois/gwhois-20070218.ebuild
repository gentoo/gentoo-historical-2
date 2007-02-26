# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gwhois/gwhois-20070218.ebuild,v 1.1 2007/02/26 23:14:51 wschlich Exp $

inherit eutils

DESCRIPTION="generic whois"
HOMEPAGE="http://gwhois.de/"
SRC_URI="http://gwhois.de/gwhois/${P/-/_}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="www-client/lynx
	net-misc/curl
	dev-lang/perl
	dev-perl/libwww-perl"

src_install() {
	dodir /etc/gwhois
	insinto /etc/gwhois
	doins pattern
	dobin gwhois
	doman gwhois.1
	dodoc TODO "${FILESDIR}/gwhois.xinetd" README.RIPE README.upgrade
	einfo ""
	einfo "See included gwhois.xinetd for an example on how to"
	einfo "use gwhois as a whois proxy using xinetd."
	einfo "Just copy gwhois.xinetd to /etc/xinetd.d/gwhois"
	einfo "and reload xinetd."
	einfo ""
}

pkg_postinst() {
	if [ -f /etc/gwhois/pattern.ripe ]; then
		ewarn ""
		ewarn "Will move old /etc/gwhois/pattern.ripe to removethis-pattern.ripe"
		ewarn "as it causes malfunction with this version."
		ewarn "If you did not modify the file, just remove it."
		ewarn ""
		mv /etc/gwhois/pattern.ripe /etc/gwhois/removethis-pattern.ripe
	fi
}
