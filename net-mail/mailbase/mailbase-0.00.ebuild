# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/mailbase/mailbase-0.00.ebuild,v 1.1 2001/02/15 21:40:34 jerry Exp $

A=""
S=${WORKDIR}
DESCRIPTION="MTA layout package"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"

RDEPEND="virtual/mta"

src_install() {
    dodir /etc/mail
    insinto /etc/mail
    doins ${FILESDIR}/aliases
}
