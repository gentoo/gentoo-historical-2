# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/autoconf.eclass,v 1.7 2001/10/13 22:02:12 danarmak Exp $
# The autoconf eclass merely adds autconf/automake deps.
ECLASS=autoconf

DESCRIPTION="Based on the $ECLASS eclass"
DEPEND="${DEPEND} sys-devel/autoconf sys-devel/automake sys-devel/make"

