# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/desklet-discreetclock/desklet-discreetclock-0.3.ebuild,v 1.2 2005/07/31 11:26:51 dholm Exp $

inherit gdesklets

DESKLET_NAME="discreetClock"

MY_P="${DESKLET_NAME}-${PV}"
S=${WORKDIR}/${DESKLET_NAME}

DESCRIPTION="A simple and discreet digital clock for gDesklets"
HOMEPAGE="http://gdesklets.gnomedesktop.org/categories.php?func=gd_show_app&gd_app_id=261"
SRC_URI="http://gdesklets.gnomedesktop.org/files/${MY_P}.tar.gz"
LICENSE="freedist"

SLOT="0"
IUSE=""
KEYWORDS="~ppc ~x86"

RDEPEND=">=gnome-extra/gdesklets-core-0.34.3"
