# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-snmp/selinux-snmp-2.20120725-r5.ebuild,v 1.1 2012/09/22 09:26:56 swift Exp $
EAPI="4"

IUSE=""
MODS="snmp"
BASEPOL="2.20120725-r5"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for snmp"

KEYWORDS="~amd64 ~x86"
