# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-postfix/selinux-postfix-20041211.ebuild,v 1.1 2004/12/12 12:39:11 kaiowas Exp $

inherit selinux-policy

TEFILES="postfix.te"
FCFILES="postfix.fc"
IUSE=""

DESCRIPTION="SELinux policy for postfix"

KEYWORDS="x86 ppc sparc amd64"

