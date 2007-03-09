# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-bgchanger/gkrellm-bgchanger-0.1.0.ebuild,v 1.6 2007/03/09 16:36:44 lack Exp $

inherit gkrellm-plugin

IUSE=""

MY_PN=gkrellmbgchg2
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Plugin for GKrellM2 to change your desktop background"
HOMEPAGE="http://www.bender-suhl.de/stefan/english/comp/gkrellmbgchg.html"
SRC_URI="http://www.bender-suhl.de/stefan/comp/sources/old/${MY_P}.tar.gz"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~x86 ppc ~sparc ~alpha amd64"

PLUGIN_SO=gkrellmbgchg.so

