# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/guile-lib/guile-lib-0.1.6.ebuild,v 1.3 2009/08/25 18:44:04 klausman Exp $

inherit eutils

DESCRIPTION="An accumulation place for pure-scheme Guile modules"
HOMEPAGE="http://home.gna.org/guile-lib/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""
RDEPEND="dev-scheme/guile"
DEPEND="${RDEPEND} !<dev-libs/g-wrap-1.9.8"

pkg_setup() {
	local g=$(guile --version|line)
	[[ ${g#* } = 1.6* ]] || {
		built_with_use dev-scheme/guile regex deprecated || die "guile must be built with USE='regex deprecated'"
	}
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "install failed"
}
