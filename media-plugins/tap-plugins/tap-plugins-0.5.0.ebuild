# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/tap-plugins/tap-plugins-0.5.0.ebuild,v 1.2 2004/06/15 23:32:24 fvdpol Exp $
#

DESCRIPTION="TAP ladspa plugins package. Contains DeEsser, Dynamics, Equalizer, Reverb, Stereo Echo, Tremolo"
HOMEPAGE="http://tap-plugins.sourceforge.net"
SRC_URI="http://umn.dl.sourceforge.net/sourceforge/tap-plugins/tap-plugins-0.5.0.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND="media-libs/ladspa-sdk"

src_compile() {
	emake || die
}

src_install() {
	dodoc COPYING README CREDITS
	dohtml ${S}/doc/*
	insinto /usr/lib/ladspa
	insopts -m0755
	doins *.so
	insinto /usr/share/ladspa/rdf
	insopts -m0644
	doins *.rdf
}
