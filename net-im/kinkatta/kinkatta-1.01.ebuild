# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer Bart Verwilst <verwilst@gentoo.org>
# /home/cvsroot/gentoo-x86/kde-base/kdenetwork/kinkatta-1.00.ebuild $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base || die

need-kde 2.2
SLOT="0"
DESCRIPTION="KDE AIM Messenger"
SRC_URI="http://ftp1.sourceforge.net/kinkatta/${P}.tar.gz"

HOMEPAGE="http://kinkatta.sourceforge.org"

