# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/kemistry/kemistry-0.7.ebuild,v 1.3 2004/03/15 14:12:00 phosphan Exp $

inherit kde-base
need-kde 3
newdepend "kde-base/kdesdk"

IUSE=""
KEYWORDS="x86"
LICENSE="GPL-2"
DESCRIPTION="Kemistry--a set of chemistry related tools for KDE."
SRC_URI="mirror://sourceforge/kemistry/${P}.tar.bz2"
HOMEPAGE="http://kemistry.sourceforge.net"

