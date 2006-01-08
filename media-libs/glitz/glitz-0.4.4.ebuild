# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glitz/glitz-0.4.4.ebuild,v 1.8 2006/01/08 12:38:48 dertobi123 Exp $

inherit eutils

DESCRIPTION="An OpenGL image compositing library"
HOMEPAGE="http://www.freedesktop.org/Software/glitz"
SRC_URI="http://cairographics.org/snapshots/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ~ppc-macos ~ppc64 sh x86"
IUSE=""

DEPEND="virtual/opengl"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README TODO
}
