# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/kdirstat/kdirstat-2.2.0.ebuild,v 1.6 2002/10/04 04:55:55 vapier Exp $

inherit kde-base

DESCRIPTION="KDirStat - nice KDE replacement to du command"
SRC_URI="http://kdirstat.sourceforge.net/download/${P}.tgz"
HOMEPAGE="http://kdirstat.sourceforge.net/"


LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86"

need-kde 3

