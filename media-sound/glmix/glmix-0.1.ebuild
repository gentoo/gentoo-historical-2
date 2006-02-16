# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/glmix/glmix-0.1.ebuild,v 1.6 2006/02/16 08:49:43 flameeyes Exp $

IUSE=""

DESCRIPTION="A 3D widget for mixing up to eight JACK audio streams down to stereo"
HOMEPAGE="http://www.ecs.soton.ac.uk/~njl98r/code/ladspa/"
SRC_URI="http://www.ecs.soton.ac.uk/~njl98r/code/ladspa/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~ppc sparc"

S="${WORKDIR}/glmix"

RDEPEND="media-sound/jack-audio-connection-kit
	 >=x11-libs/gtkglext-1.0.0
	 >=x11-libs/gtk+-2.0.0"

DEPEND="${RDEPEND}
	 >=dev-util/pkgconfig-0.12.0"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin glmix || die "dobin failed"
	dodoc README TODO
}
