# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-postgresql/selinux-postgresql-20050219.ebuild,v 1.1 2005/02/25 08:14:35 kaiowas Exp $

inherit selinux-policy

TEFILES="postgresql.te"
FCFILES="postgresql.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050224"

DESCRIPTION="SELinux policy for PostgreSQL"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

