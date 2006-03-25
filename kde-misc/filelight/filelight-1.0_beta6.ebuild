# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/filelight/filelight-1.0_beta6.ebuild,v 1.5 2006/03/25 03:13:46 flameeyes Exp $

inherit kde eutils

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Filelight is a tool to display where the space is used on the harddisk"
HOMEPAGE="http://www.methylblue.com/filelight/"
SRC_URI="http://www.methylblue.com/filelight/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ppc ~sparc x86"
IUSE=""

need-kde 3.2

src_unpack() {
	kde_src_unpack

	# Unconditionally use -fPIC for libs (#55238)
	epatch ${FILESDIR}/${P}-pic.patch

	rm -f ${S}/configure
}
