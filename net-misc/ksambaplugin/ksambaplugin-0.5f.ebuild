# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ksambaplugin/ksambaplugin-0.5f.ebuild,v 1.2 2004/01/19 02:52:23 caleb Exp $

inherit kde
need-kde 3

DESCRIPTION="KDE 3 plugin for configuring a SAMBA server"
HOMEPAGE="http://ksambakdeplugin.sourceforge.net/"
SRC_URI="mirror://sourceforge/ksambakdeplugin/${P/f/}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
IUSE="debug"

DEPEND=">=kde-base/kdebase-3"
RDEPEND="${DEPEND} >=net-fs/samba-2.2.7"
S=${WORKDIR}/${P/f/}

use debug && myconf="$myconf --enable-debug --enable-profile"
myconf="$myconf --enable-sso"
