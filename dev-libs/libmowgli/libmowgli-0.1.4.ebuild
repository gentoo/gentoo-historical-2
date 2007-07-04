# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmowgli/libmowgli-0.1.4.ebuild,v 1.3 2007/07/04 16:08:17 chainsaw Exp $

DESCRIPTION="High-performance C development framework. Can be used stand-alone or as a supplement to GLib."
HOMEPAGE="http://www.atheme-project.org/projects/mowgli.shtml"
SRC_URI="http://sidhe.atheme-project.org/~nenolod/mowgli/${P}.tgz"
IUSE="examples"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

src_compile() {
	econf \
		$(use_enable examples) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS
}
