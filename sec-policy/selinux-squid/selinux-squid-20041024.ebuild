# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-squid/selinux-squid-20041024.ebuild,v 1.1 2004/10/27 11:02:12 kaiowas Exp $

inherit selinux-policy

TEFILES="squid.te"
FCFILES="squid.fc"
IUSE=""

DESCRIPTION="SELinux policy for squid"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

RDEPEND=">=sec-policy/selinux-base-policy-20041023"

