# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/desklet-regexp/desklet-regexp-1.0.ebuild,v 1.5 2006/03/24 21:18:40 agriffis Exp $

inherit gdesklets

DESKLET_NAME="regexpcontrol"

S=${WORKDIR}

DESCRIPTION="The RegExp Control for gDesklets"
HOMEPAGE="http://gdesklets.gnomedesktop.org/categories.php?func=gd_show_app&gd_app_id=227"
SRC_URI="http://gdesklets.gnomedesktop.org/files/${DESKLET_NAME}.tar.gz"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ia64 ~ppc x86"
LICENSE="GPL-2"

RDEPEND=">=gnome-extra/gdesklets-core-0.34.3"

