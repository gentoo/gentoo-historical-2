# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-im/kxicq2/kxicq2-0.7.ebuild,v 1.3 2001/12/23 21:35:16 danarmak Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

need-kde 2.1

S="${WORKDIR}/kxicq2-0.7.b4"
SRC_URI="http://apps.kde.com/nf/2/counter/vid/4702/dld0/kxicq2-0.7.b4.tar.gz"

HOMEPAGE="http://www.kxicq.org"
DESCRIPTION="KDE 2.x ICQ Client"


