# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/gmm/gmm-4.0.0.ebuild,v 1.2 2010/01/23 03:45:25 abcd Exp $

DESCRIPTION="Generic C++ template library for sparse, dense and skyline matrices"
SRC_URI="http://download.gna.org/getfem/stable/${P}.tar.gz"
HOMEPAGE="http://www-gmm.insa-toulouse.fr/getfem/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS
}
