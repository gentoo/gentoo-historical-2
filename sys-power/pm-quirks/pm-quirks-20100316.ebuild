# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/pm-quirks/pm-quirks-20100316.ebuild,v 1.4 2010/06/05 18:55:46 armin76 Exp $

EAPI=3
inherit multilib

DESCRIPTION="Video Quirks database for pm-utils"
HOMEPAGE="http://pm-utils.freedesktop.org/"
SRC_URI="http://pm-utils.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto /usr/$(get_libdir)/pm-utils/video-quirks
	doins *.quirkdb || die
}
