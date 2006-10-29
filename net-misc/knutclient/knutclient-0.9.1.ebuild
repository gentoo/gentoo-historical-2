# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/knutclient/knutclient-0.9.1.ebuild,v 1.2 2006/10/29 20:14:15 flameeyes Exp $

inherit kde

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Client for the NUT UPS monitoring daemon"
HOMEPAGE="ttp://www.alo.cz/knutclient/index.html"
SRC_URI="ftp://ftp.buzuluk.cz/pub/alo/knutclient/stable/${MY_P}.tar.gz
	mirror://gentoo/kde-admindir-3.5.5.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

need-kde 3.5

PATCHES="${FILESDIR}/knutclient-0.9.diff"