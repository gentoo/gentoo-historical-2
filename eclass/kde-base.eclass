# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/kde-base.eclass,v 1.17 2002/10/25 19:55:52 vapier Exp $
# This is the kde ebuild for std. kde-dependant apps which follow configure/make/make install
# procedures and have std. configure options.
inherit kde
ECLASS=kde-base
INHERITED="$INHERITED $ECLASS"

newdepend /c

DESCRIPTION="Based on the $ECLASS eclass"
HOMEPAGE="http://apps.kde.com/"





