# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-squid/selinux-squid-20050626.ebuild,v 1.1.1.1 2005/11/30 10:02:14 chriswhite Exp $

inherit selinux-policy

TEFILES="squid.te"
FCFILES="squid.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050618"

DESCRIPTION="SELinux policy for squid"

KEYWORDS="x86 ppc sparc amd64"

