# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdestudio/kdestudio-2.0.0.ebuild,v 1.1 2001/12/14 06:43:27 verwilst Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base

HOMEPAGE="http://www.thekompany.com/projects/kdestudio"
DESCRIPTION="KDE 2.x IDE"

SRC_URI="ftp://ftp.rygannon.com/pub/KDE_Studio/source/${P}.tar.gz"

need-kdelibs 2.1
need-qt 2.3


