# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/superadduser/superadduser-1.0.9.ebuild,v 1.8 2004/11/03 04:17:55 psi29a Exp $

DESCRIPTION="Interactive adduser script from Slackware"
SRC_URI=""
HOMEPAGE="http://www.interlude.org.uk/unix/slackware/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ppc sparc alpha hppa mips ~amd64 ia64 ~ppc64 arm"
IUSE=""

RDEPEND="sys-apps/shadow"

src_install() {
	dosbin ${FILESDIR}/${PV}/superadduser
	doman ${FILESDIR}/superadduser.8
}
