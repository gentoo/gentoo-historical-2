# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/kcmpureftpd/kcmpureftpd-0.6.ebuild,v 1.1 2002/01/15 18:56:11 verwilst Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

need-kde 2.1

DESCRIPTION="Pure-FTPd KDE Kcontrol Configuration Panel"
SRC_URI="http://prdownloads.sourceforge.net/pureftpd/${P}.tar.gz"
HOMEPAGE="http://lkr.sourceforge.net/kcmpureftpd/index.html"
