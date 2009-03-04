# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdialog/kdialog-4.2.1.ebuild,v 1.1 2009/03/04 21:19:06 alexxy Exp $

EAPI="2"

KMNAME="kdebase"
KMMODULE="apps/kdialog"
inherit kde4-meta

DESCRIPTION="KDialog can be used to show nice dialog boxes from shell scripts"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}
	kernel_linux? (
	|| ( sys-apps/eject
		sys-block/unieject ) )"
