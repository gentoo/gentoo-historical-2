# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/kphone/kphone-3.11.ebuild,v 1.1 2003/07/07 20:05:27 caleb Exp $

inherit kde-base || die

need-kde 3
LICENSE="GPL-2"
DESCRIPTION="a SIP user agent for Linux, with which you can initiate VoIP connections over the Internet."
SRC_URI="http://www.wirlab.net/kphone/${P}.tgz"
HOMEPAGE="http://www.wirlab.net/kphone/index.html"
KEYWORDS="x86"

# Fix for our kde location
myconf="$myconf --with-extra-libs=$KDEDIR/lib"
