# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/cervisia/cervisia-4.9.5.ebuild,v 1.3 2013/01/27 15:00:27 ago Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdesdk"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="Cervisia - A KDE CVS frontend"
KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	dev-vcs/cvs
"
