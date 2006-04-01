# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/pidof-bsd/pidof-bsd-20050501-r1.ebuild,v 1.1 2006/04/01 17:01:15 flameeyes Exp $

inherit base bsdmk

DESCRIPTION="pidof(1) utility for *BSD"
HOMEPAGE="http://people.freebsd.org/~novel/pidof.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="!sys-process/psmisc"

S="${WORKDIR}/pidof"

PATCHES="${FILESDIR}/${P}-gfbsd.patch"

src_install() {
	into /
	dobin pidof
}

