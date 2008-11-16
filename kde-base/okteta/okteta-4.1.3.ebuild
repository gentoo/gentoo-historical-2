# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/okteta/okteta-4.1.3.ebuild,v 1.2 2008/11/16 08:24:29 vapier Exp $

EAPI="2"

KMNAME=kdeutils
inherit kde4-meta

DESCRIPTION="KDE binary file editor"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

# 9/ 40 Testing libpiecetable-grouppiecetablec***Failed
RESTRICT="test"
