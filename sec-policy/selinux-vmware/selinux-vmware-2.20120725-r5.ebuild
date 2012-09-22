# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-vmware/selinux-vmware-2.20120725-r5.ebuild,v 1.1 2012/09/22 09:27:20 swift Exp $
EAPI="4"

IUSE=""
MODS="vmware"
BASEPOL="2.20120725-r5"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for vmware"

KEYWORDS="~amd64 ~x86"
DEPEND="${DEPEND}
	sec-policy/selinux-xserver
"
RDEPEND="${DEPEND}"
