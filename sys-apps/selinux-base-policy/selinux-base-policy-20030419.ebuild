# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/selinux-base-policy/selinux-base-policy-20030419.ebuild,v 1.2 2003/04/20 03:07:50 pebenito Exp $

IUSE="selinux"

DESCRIPTION="Gentoo base policy for SELinux"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
RDEPEND="|| (
		>=sys-kernel/selinux-sources-2.4.20-r1
		>=sys-kernel/hardened-sources-2.4.20-r1
	    )"
DEPEND=""
S=${WORKDIR}/base-policy

pkg_setup() {
        use selinux || eend 1 "You must have selinux in your USE"
}

src_install() {
	mkdir -p ${D}/etc/security/selinux/src
	mv ${S} ${D}/etc/security/selinux/src/policy
}
