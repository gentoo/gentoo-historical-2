# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/scrot/scrot-0.8.ebuild,v 1.8 2004/09/11 20:51:07 ka0ttic Exp $

DESCRIPTION="Screen Shooter"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"
HOMEPAGE="http://www.linuxbrit.co.uk/"

SLOT="0"
LICENSE="as-is BSD"
KEYWORDS="x86 ~alpha ~ppc ~amd64 ~sparc ppc64"
IUSE=""

DEPEND=">=media-libs/imlib2-1.0.3
	>=media-libs/giblib-1.2.3"

src_install () {
	make DESTDIR=${D} install || die

	dodoc TODO README AUTHORS ChangeLog

	insinto /usr/share/bash-completion
	newins ${FILESDIR}/${PN}.bash-completion ${PN}
}

pkg_postinst() {
	echo
	einfo "To enable command-line completion for scrot, issue the following"
	einfo "command as root:"
	einfo "  ln -s /usr/share/bash-completion/scrot /etc/bash_completion.d/"
	echo
}
