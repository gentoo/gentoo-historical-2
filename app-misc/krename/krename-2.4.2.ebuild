# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/krename/krename-2.4.2.ebuild,v 1.1 2003/03/29 04:17:10 seemant Exp $

IUSE=""

inherit kde-base

DESCRIPTION="KRename - a very powerful batch file renamer"
HOMEPAGE="http://www.krename.net/"
SRC_URI="mirror://sourceforge/krename/${P}.tar.bz2"


LICENSE="GPL-2"
KEYWORDS="~x86"

need-kde 3
