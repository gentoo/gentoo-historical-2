# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-postfix/selinux-postfix-20050918.ebuild,v 1.2 2005/10/18 10:38:58 kaiowas Exp $

inherit selinux-policy

TEFILES="postfix.te"
FCFILES="postfix.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050618"

DESCRIPTION="SELinux policy for postfix"

KEYWORDS="amd64 mips ppc sparc x86"

