# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mozilla-launcher/mozilla-launcher-1.21.ebuild,v 1.4 2004/10/03 04:42:43 vapier Exp $

DESCRIPTION="Script that launches mozilla or firefox"
HOMEPAGE=""
SRC_URI="mirror://gentoo/${P}.bz2
	http://dev.gentoo.org/~agriffis/${PN}/${P}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_install() {
	exeinto /usr/libexec
	newexe ${P} mozilla-launcher || die
}

pkg_postinst() {
	local f

	find ${ROOT}/usr/bin -type l -maxdepth 1 | \
	while read f; do
		[[ $(readlink ${f}) == mozilla-launcher ]] || continue
		einfo "Updating ${f} symlink to /usr/libexec/mozilla-launcher"
		ln -sfn /usr/libexec/mozilla-launcher ${f}
	done
}
