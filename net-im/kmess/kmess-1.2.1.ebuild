# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/kmess/kmess-1.2.1.ebuild,v 1.4 2003/07/31 03:35:35 caleb Exp $

inherit kde-base

need-kde 3

IUSE=""
DESCRIPTION="MSN Messenger clone for KDE"
SRC_URI="mirror://sourceforge/kmess/${P}.tar.gz"
HOMEPAGE="http://kmess.sourceforge.net"

LICENSE="GPL-2"
KEYWORDS="x86 ~sparc"

DEPEND="kde-base/kdenetwork"
