# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/kgpg/kgpg-0.9.2.ebuild,v 1.4 2003/02/13 06:22:40 vapier Exp $

inherit kde-base 
need-kde 3 

IUSE=""
DESCRIPTION="KDE integration for GnuPG" 
SRC_URI="http://devel-home.kde.org/~kgpg/src/${P}.tar.gz" 
HOMEPAGE="http://devel-home.kde.org/~kgpg/index.html" 
LICENSE="GPL-2" 
KEYWORDS="x86" 

newdepend "app-crypt/gnupg"
