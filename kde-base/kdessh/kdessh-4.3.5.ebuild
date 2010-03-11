# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdessh/kdessh-4.3.5.ebuild,v 1.3 2010/03/11 18:35:26 ranger Exp $

EAPI="2"

KMNAME="kdeutils"
inherit kde4-meta

DESCRIPTION="KDE frontend to ssh"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="virtual/ssh"
