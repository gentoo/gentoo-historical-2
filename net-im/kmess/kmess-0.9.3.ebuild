# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-im/kmess/kmess-0.9.3.ebuild,v 1.2 2002/05/21 18:14:11 danarmak Exp $

inherit kde-base || die

S="${WORKDIR}/${P}"
need-kde 3
DESCRIPTION="KDE MSN Messenger"
SRC_URI="http://prdownloads.sourceforge.net/kmess/${P}.tar.gz"
HOMEPAGE="http://kmess.sourceforge.net"
