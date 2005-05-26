# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-bind/selinux-bind-20050526.ebuild,v 1.1 2005/05/26 10:07:59 kaiowas Exp $

inherit selinux-policy

TEFILES="named.te"
FCFILES="named.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050224"

DESCRIPTION="SELinux policy for BIND"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

