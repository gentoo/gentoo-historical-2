# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-admin/ktail/ktail-0.6.1.ebuild,v 1.3 2002/07/25 12:57:05 seemant Exp $
inherit kde-base || die

need-kde 3

DESCRIPTION="ktail monitors multiple files and/or command output in one window."
SRC_URI="http://www.franken.de/users/duffy1/rjakob/${P}.tar.bz2"
HOMEPAGE="http://www.franken.de/users/duffy1/rjakob/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
