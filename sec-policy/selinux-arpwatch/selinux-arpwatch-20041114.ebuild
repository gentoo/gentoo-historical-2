# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-arpwatch/selinux-arpwatch-20041114.ebuild,v 1.1 2004/11/14 20:46:18 kaiowas Exp $

inherit selinux-policy

TEFILES="arpwatch.te"
FCFILES="arpwatch.fc"
IUSE=""

DESCRIPTION="SELinux policy for arpwatch"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

