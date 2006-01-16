# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/desklet-ftb/desklet-ftb-0.3.2.ebuild,v 1.2 2006/01/16 18:09:10 nixphoeni Exp $

inherit gdesklets

DESKLET_NAME="FTB"

MY_P="${DESKLET_NAME}-${PV}"
S=${WORKDIR}/Displays/${DESKLET_NAME}

DESCRIPTION="Configurable, stackable system monitors"
HOMEPAGE="http://www.gdesklets.org/?mod=project/releases&pid=16"
SRC_URI="http://www.gdesklets.org/projects/16/releases/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=gnome-extra/gdesklets-core-0.34.3"
