# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeedu/kdeedu-3.2.3.ebuild,v 1.6 2004/08/08 12:52:12 gmsoft Exp $

inherit kde-dist eutils

DESCRIPTION="KDE educational apps"

KEYWORDS="x86 ~ppc ~sparc ~alpha hppa amd64 ~ia64"
IUSE=""

src_unpack()
{
	kde_src_unpack
}
