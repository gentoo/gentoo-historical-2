# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/kcmpureftpd/kcmpureftpd-0.6.ebuild,v 1.5 2002/07/07 08:24:12 phoenix Exp $

inherit kde-base || die

need-kde 2.1

KEYWORDS="x86"
LICENSE="GPL-2"
DESCRIPTION="Pure-FTPd KDE Kcontrol Configuration Panel"
SRC_URI="mirror://sourceforge/pureftpd/${P}.tar.gz"
HOMEPAGE="http://lkr.sourceforge.net/kcmpureftpd/index.html"
