# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-procmail/selinux-procmail-20051122.ebuild,v 1.2 2005/12/02 20:07:16 kaiowas Exp $

inherit selinux-policy

TEFILES="procmail.te"
FCFILES="procmail.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050224"

DESCRIPTION="SELinux policy for procmail"

KEYWORDS="amd64 mips ppc sparc x86"

