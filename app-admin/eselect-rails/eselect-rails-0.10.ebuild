# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-rails/eselect-rails-0.10.ebuild,v 1.1 2007/09/01 05:08:49 nichoj Exp $

DESCRIPTION="Manages Ruby on Rails symlinks"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

# Block versions of rails that install /usr/bin/rails
# rails PDEPENDS on this package, so upgrade paths should be sane without
# blockers. See: http://planet.gentoo.org/developers/zmedico/2007/08/19/using_blockers_to_adjust_merge_order
RDEPEND=">=app-admin/eselect-1.0.10
	!<dev-ruby/rails-1.1.6-r2
	!~dev-ruby/rails-1.2.0
	!~dev-ruby/rails-1.2.1
	!~dev-ruby/rails-1.2.2
	!=dev-ruby/rails-1.2.3
"

src_install() {
	insinto /usr/share/eselect/modules
	doins *.eselect || die "doins failed"
}
