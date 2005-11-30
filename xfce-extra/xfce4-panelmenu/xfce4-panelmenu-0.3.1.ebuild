# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/xfce4-panelmenu/xfce4-panelmenu-0.3.1.ebuild,v 1.1.1.1 2005/11/30 09:38:57 chriswhite Exp $

PLUGIN=1
inherit xfce4

MY_P="${MY_P/panelmenu/panel-menu}"

DESCRIPTION="Xfce4 panel menu plugin"
SRC_URI="http://download.berlios.de/${PN/-/}/${MY_P}.tar.gz"
HOMEPAGE="https://developer.berlios.de/projects/xfce4panelmenu"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

XFCE_S="${WORKDIR}/${MY_P}"
