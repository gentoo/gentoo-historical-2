# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/kmyfirewall/kmyfirewall-0.9.6.ebuild,v 1.4 2004/01/07 01:44:47 weeve Exp $
inherit kde
need-kde 3

IUSE=""
DESCRIPTION="Graphical KDE iptables configuration tool"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://kmyfirewall.sourceforge.net/"
RESTRICT="nomirror"

LICENSE="GPL-2"
KEYWORDS="x86 ~sparc"

src_unpack() {
	kde_src_unpack
	sed -i 's:gentoo_mode=false:gentoo_mode=true:' \
	${S}/kmyfirewall/kmyfirewallrc
}
