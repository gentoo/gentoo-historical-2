# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-ntp/selinux-ntp-20050219.ebuild,v 1.1 2005/02/25 08:06:48 kaiowas Exp $

inherit selinux-policy

TEFILES="ntpd.te"
FCFILES="ntpd.fc"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20041023"

DESCRIPTION="SELinux policy for the network time protocol daemon"

KEYWORDS="~x86 ~ppc ~sparc ~amd64"

