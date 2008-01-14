# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/inform/inform-6.31.1.ebuild,v 1.2 2008/01/14 00:44:20 opfer Exp $

DESCRIPTION="design system for interactive fiction"
HOMEPAGE="http://www.inform-fiction.org/"
SRC_URI="http://mirror.ifarchive.org/if-archive/infocom/compilers/inform6/source/${P}.tar.gz"

LICENSE="Inform"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc-macos ~sparc ~x86"
IUSE="emacs"
PDEPEND="emacs? ( app-emacs/inform-mode )"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README VERSION
	docinto tutorial
	dodoc tutor/README tutor/*.txt tutor/*.inf
	mv "${D}"/usr/share/${PN}/manual "${D}"/usr/share/doc/${PF}/html
	rmdir "${D}"/usr/share/inform/{include,module}
}
