# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-ladspa/xmms-ladspa-0.7.ebuild,v 1.5 2004/06/29 16:36:42 dholm Exp $

MY_PN=${PN/-/_}
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="XMMS LADSPA Plugin"
HOMEPAGE="http://www.ecs.soton.ac.uk/~njl98r/code/ladspa/"
SRC_URI="http://www.ecs.soton.ac.uk/~njl98r/code/ladspa/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 ~amd64 ~ppc"
SLOT="0"
DEPEND="media-plugins/swh-plugins
	media-sound/xmms"

IUSE=""

src_compile() {
	emake || die
}

src_install() {
	exeinto /usr/lib/xmms/Effect
	doexe ${S}/ladspa.so || die
	dodoc COPYING PLUGINS README || die
}
