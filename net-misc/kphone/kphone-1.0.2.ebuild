# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/kphone/kphone-1.0.2.ebuild,v 1.5 2003/07/22 20:14:28 vapier Exp $

inherit kde-base

S="${WORKDIR}/kphone-1.0"
need-kde 3
LICENSE="GPL-2"
DESCRIPTION="a SIP user agent for Linux, with which you can initiate VoIP connections over the Internet."
SRC_URI="http://www.wirlab.net/kphone/kphone-1.0.2.tgz"
HOMEPAGE="http://www.wirlab.net/kphone/index.html"
KEYWORDS="x86 sparc "

# Fix for our kde location
myconf="$myconf --with-extra-libs=$KDEDIR/lib"
