# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/calcchecksum/calcchecksum-1.6_pre1.ebuild,v 1.7 2005/01/01 12:26:30 eradicator Exp $

inherit kde

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="CalcChecksum is a tool for calculating MD5 and CRC32, TIGER, HAVAL, SHA and some other checksums."
HOMEPAGE="http://calcchecksum.sourceforge.net/"
SRC_URI="mirror://sourceforge/calcchecksum/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64"
IUSE=""

need-kde 3.1
