# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/shorewall-shell/shorewall-shell-4.0.9.ebuild,v 1.2 2008/02/25 18:11:55 pva Exp $

# Select version (stable, RC, Beta, upstream patched):
MY_P_TREE="4.0"   # stable/devel (eg. "4.0" or "development/4.0")
MY_P_BETA=""      # stable or experimental (eg. "-RC1" or "-Beta4")
MY_P_PATCH=""     # upstream patch (eg. ".2")

MY_P="shorewall-${PV}"

DESCRIPTION="Shoreline Firewall shell-based compiler."
HOMEPAGE="http://www.shorewall.net/"
SRC_URI="http://www1.shorewall.net/pub/shorewall/${MY_P_TREE}/${MY_P}${MY_P_BETA}/${P}${MY_P_PATCH}${MY_P_BETA}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="net-firewall/iptables
	sys-apps/iproute2
	!<net-firewall/shorewall-4.0"

PDEPEND="~net-firewall/shorewall-common-${PV}"

src_compile() {
	einfo "Nothing to compile."
}

src_install() {
	cd "${WORKDIR}/${P}${MY_P_PATCH}${MY_P_BETA}"
	PREFIX="${D}" ./install.sh || die "install.sh failed"

	dodoc releasenotes.txt
}

pkg_postinst() {
	einfo
	einfo "Documentation is available at http://www.shorewall.net"
	einfo
	elog "In order to use the shell compiler you need to add"
	elog "SHOREWALL_COMPILER=shell"
	elog "to shorewall.conf unless you do not have the Perl compiler."
	einfo
	einfo "Please read the included release notes for more information."
	einfo
	einfo "Known problems:"
	einfo "http://www1.shorewall.net/pub/shorewall/${MY_P_TREE}/${MY_P}${MY_P_BETA}/known_problems.txt"
	einfo
}
