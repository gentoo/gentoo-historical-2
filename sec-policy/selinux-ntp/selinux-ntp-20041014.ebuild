# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-ntp/selinux-ntp-20041014.ebuild,v 1.1 2004/10/23 13:48:48 kaiowas Exp $

inherit selinux-policy

TEFILES="ntpd.te"
FCFILES="ntpd.fc"
IUSE=""

DESCRIPTION="SELinux policy for the network time protocol daemon"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

RDEPEND=">=sec-policy/selinux-base-policy-20041023"

