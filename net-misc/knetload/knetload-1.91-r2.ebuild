# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/knetload/knetload-1.91-r2.ebuild,v 1.10 2002/12/09 04:33:16 manson Exp $

inherit kde-base || die

need-kde 2.1.1

DESCRIPTION="A Network applet for KDE2"
SRC_URI="http://kde.quakenet.eu.org/files/${P}.tar.gz"
HOMEPAGE="http://kde.quakenet.eu.org/knetload.shtml"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

