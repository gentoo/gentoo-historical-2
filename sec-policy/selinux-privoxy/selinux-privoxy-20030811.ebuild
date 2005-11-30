# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-privoxy/selinux-privoxy-20030811.ebuild,v 1.1.1.1 2005/11/30 10:02:13 chriswhite Exp $

TEFILES="privoxy.te"
FCFILES="privoxy.fc"
IUSE=""

inherit selinux-policy

DESCRIPTION="SELinux policy for privoxy"

KEYWORDS="x86 ppc sparc amd64"

