# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-kerberos/selinux-kerberos-20050626.ebuild,v 1.1 2005/06/26 18:22:09 kaiowas Exp $

inherit selinux-policy

TEFILES="kerberos.te"
FCFILES="kerberos.fc"
MACROS="kerberos_macros.te"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050618"

DESCRIPTION="SELinux policy for kerberos servers"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

