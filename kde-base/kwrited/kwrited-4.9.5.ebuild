# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kwrited/kwrited-4.9.5.ebuild,v 1.2 2013/01/27 12:41:07 ago Exp $

EAPI=4
KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="KDE daemon listening for wall and write messages."
KEYWORDS="amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	|| ( >=sys-libs/libutempter-1.1.5 >=sys-freebsd/freebsd-lib-9.0 )
"
RDEPEND="${DEPEND}"
