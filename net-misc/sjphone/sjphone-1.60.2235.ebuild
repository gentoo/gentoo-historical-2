# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sjphone/sjphone-1.60.2235.ebuild,v 1.2 2007/07/22 08:00:32 dberkholz Exp $

inherit eutils

MY_P="SJphoneLnx-${PV}"
DESCRIPTION=" VOIP softphone supports both SIP and H.323 standards "
HOMEPAGE="http://www.sjlabs.com/sjp.html"
SRC_URI="http://www.sjlabs.com/preview/linux/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp"
S=${WORKDIR}/${MY_P}

src_install() {
	insinto /opt/sjphone
	doins -r lib/*
	fperms a+x /opt/sjphone/sjphone

	sed -i -e 's:$(dirname "$0"):/opt/sjphone:' \
		-e 's:$WD/lib:$WD:' sjphone
	dobin sjphone
	dodoc LICENSE README
	doicon lib/sjphone.png
	make_desktop_entry sjphone
}
