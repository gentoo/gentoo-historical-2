# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-dkim/selinux-dkim-2.20120215-r1.ebuild,v 1.1 2012/06/27 20:33:59 swift Exp $
EAPI="4"

IUSE=""
MODS="dkim"
BASEPOL="2.20120215-r13"
DEPEND=">=sec-policy/selinux-base-policy-2.20120215-r1
	>=sec-policy/selinux-milter-2.20120215"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for dkim"

KEYWORDS="~amd64 ~x86"
