# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/kemerge/kemerge-0.4.ebuild,v 1.6 2002/07/17 20:43:16 drobbins Exp $

inherit kde-base || die

need-kde 3
DESCRIPTION="Graphical KDE emerge tool"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
SLOT="0"
HOMEPAGE="http://kemerge.sourceforge.net/"
LICENSE="GPL-2"
newdepend ">=app-admin/kebuildpart-0.1
	   >=app-admin/kebuild-0.1"

