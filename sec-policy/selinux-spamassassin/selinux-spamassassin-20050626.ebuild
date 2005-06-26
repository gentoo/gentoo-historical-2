# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sec-policy/selinux-spamassassin/selinux-spamassassin-20050626.ebuild,v 1.3 2005/06/26 17:43:43 kaiowas Exp $

inherit selinux-policy

TEFILES="spamassassin.te spamc.te spamd.te"
FCFILES="spamassassin.fc spamc.fc spamd.fc"
MACROS="spamassassin_macros.te"
IUSE=""
RDEPEND=">=sec-policy/selinux-base-policy-20050618"

DESCRIPTION="SELinux policy for SpamAssassin"

KEYWORDS="x86 ppc sparc amd64"


