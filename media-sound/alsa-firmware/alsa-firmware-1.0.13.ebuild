# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsa-firmware/alsa-firmware-1.0.13.ebuild,v 1.2 2006/10/11 19:36:43 corsair Exp $

MY_P="${P/_rc/rc}"

DESCRIPTION="Advanced Linux Sound Architecture firmware"
HOMEPAGE="http://www.alsa-project.org/"
SRC_URI="mirror://alsaproject/firmware/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

DEPEND=""

src_compile() {
	econf \
		--with-hotplug-dir=/lib/firmware \
		|| die "configure failed"

	emake || die "make failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README
}
