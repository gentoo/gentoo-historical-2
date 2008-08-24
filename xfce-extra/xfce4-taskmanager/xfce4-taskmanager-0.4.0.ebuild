# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-taskmanager/xfce4-taskmanager-0.4.0.ebuild,v 1.6 2008/08/24 13:58:09 corsair Exp $

inherit autotools eutils xfce44

xfce44

DESCRIPTION="Task Manager"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
HOMEPAGE="http://goodies.xfce.org/projects/applications/xfce4-taskmanager"
SRC_URI="http://goodies.xfce.org/releases/${PN}/${P}${COMPRESS}"

RDEPEND=">=xfce-base/libxfcegui4-${XFCE_MASTER_VERSION}
	>=xfce-base/libxfce4util-${XFCE_MASTER_VERSION}"

DOCS="AUTHORS ChangeLog NEWS README THANKS TODO"
