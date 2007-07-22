# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/mozilla-launcher/mozilla-launcher-1.49.ebuild,v 1.3 2007/07/22 06:15:33 dberkholz Exp $

inherit eutils

DESCRIPTION="Script that launches mozilla or firefox"
HOMEPAGE="http://dev.gentoo.org/~agriffis/dist/"
SRC_URI="mirror://gentoo/${P}.bz2 \
		http://dev.gentoo.org/~agriffis/dist/${P}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE=""

DEPEND=""
RDEPEND="x11-apps/xdpyinfo"

S=${WORKDIR}

src_install() {
	exeinto /usr/libexec
	newexe ${P} mozilla-launcher || die
}

pkg_postinst() {
	local f

	find ${ROOT}/usr/bin -maxdepth 1 -type l | \
	while read f; do
		[[ $(readlink ${f}) == mozilla-launcher ]] || continue
		einfo "Updating ${f} symlink to /usr/libexec/mozilla-launcher"
		ln -sfn /usr/libexec/mozilla-launcher ${f}
	done
}
