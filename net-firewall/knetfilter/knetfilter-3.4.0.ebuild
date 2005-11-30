# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/knetfilter/knetfilter-3.4.0.ebuild,v 1.1 2005/05/01 13:44:02 carlo Exp $

inherit kde

DESCRIPTION="Manage Iptables firewalls with this KDE app"
HOMEPAGE="http://expansa.sns.it:8080/knetfilter/"
SRC_URI="http://expansa.sns.it:8080/knetfilter/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"
IUSE=""

DEPEND=">=net-firewall/iptables-1.2.5"
need-kde 3

src_unpack() {
	kde_src_unpack
	make distclean
	kde_sandbox_patch ${S}/src ${S}/src/scripts
}
