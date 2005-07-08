# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/linuxtv-dvb-headers/linuxtv-dvb-headers-3.1.ebuild,v 1.3 2005/07/08 12:00:41 zzam Exp $

inherit eutils

DESCRIPTION="Header files for DVB kernel modules"
HOMEPAGE="http://www.linuxtv.org"
SRC_URI="mirrors://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND=""

src_install()
{
	insinto /usr/include/dvb/linux/dvb
	doins *.h || die "doins failed"
}
