# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebugdialog/kdebugdialog-4.6.2.ebuild,v 1.4 2011/06/01 18:07:47 ranger Exp $

EAPI=3

KDE_HANDBOOK="optional"
KMNAME="kdebase-runtime"
inherit kde4-meta

DESCRIPTION="KDE: A dialog box for setting preferences for debug output"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"
