# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/guarddog/guarddog-2.2.0.ebuild,v 1.3 2004/03/20 07:34:37 mr_bones_ Exp $

inherit kde

need-kde 3

DESCRIPTION="Firewall configuration utility for KDE 3"
SRC_URI="http://www.simonzone.com/software/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.simonzone.com/software/guarddog/"

KEYWORDS="~x86 ~sparc"
LICENSE="GPL-2"

newrdepend ">=net-firewall/iptables-1.2.5"
