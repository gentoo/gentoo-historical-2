# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/superadduser/superadduser-1.0.8.ebuild,v 1.1 2004/06/01 21:11:12 seemant Exp $

DESCRIPTION="Interactive adduser script from Slackware"
SRC_URI=""
HOMEPAGE="http://www.interlude.org.uk/unix/slackware/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~mips ~amd64 ~ia64 ~ppc64"

RDEPEND="sys-apps/shadow"

src_install() {
	dosbin ${FILESDIR}/${PV}/superadduser
	doman ${FILESDIR}/${PV}/superadduser.8
}
