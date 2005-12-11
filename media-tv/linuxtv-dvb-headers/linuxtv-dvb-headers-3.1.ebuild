# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/linuxtv-dvb-headers/linuxtv-dvb-headers-3.1.ebuild,v 1.9 2005/12/11 14:35:05 agriffis Exp $

inherit eutils

DESCRIPTION="Virtual Package installing the Header files for DVB"
HOMEPAGE="http://www.linuxtv.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc x86"
IUSE=""
RDEPEND="|| (
		>=sys-kernel/linux-headers-2.6.11-r2
		media-tv/linuxtv-dvb
	)"
