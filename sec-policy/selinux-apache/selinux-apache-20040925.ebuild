# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-apache/selinux-apache-20040925.ebuild,v 1.3 2004/11/23 16:59:37 kaiowas Exp $

inherit selinux-policy

TEFILES="apache.te"
FCFILES="apache.fc"
MACROS="apache_macros.te"
IUSE=""

DESCRIPTION="SELinux policy for Apache HTTPD"

KEYWORDS="x86 ppc sparc amd64"

RDEPEND=">=sec-policy/selinux-base-policy-20041023"

