# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/knetfilter/knetfilter-3.1.1.ebuild,v 1.7 2004/06/24 22:41:31 agriffis Exp $

inherit kde

need-kde 3.1

LICENSE="GPL-2"
DESCRIPTION="Manage Iptables firewalls with this KDE app"
SRC_URI="http://expansa.sns.it:8080/knetfilter/${P}.tar.gz"
HOMEPAGE="http://expansa.sns.it:8080/knetfilter/"
KEYWORDS="x86 sparc"

newdepend ">=net-firewall/iptables-1.2.5"

src_unpack() {
	kde_src_unpack
	cd ${S}
	make distclean
	kde_sandbox_patch ${S}/src ${S}/src/scripts
}
