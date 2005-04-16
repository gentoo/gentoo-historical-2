# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-postfix/selinux-postfix-20050417.ebuild,v 1.1 2005/04/16 20:45:57 kaiowas Exp $

inherit selinux-policy

TEFILES="postfix.te"
FCFILES="postfix.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050224"

DESCRIPTION="SELinux policy for postfix"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

