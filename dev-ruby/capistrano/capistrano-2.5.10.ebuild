# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/capistrano/capistrano-2.5.10.ebuild,v 1.1 2009/11/29 07:49:32 graaff Exp $

inherit gems

DESCRIPTION="A distributed application deployment system"
HOMEPAGE="http://capify.org/"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""
USE_RUBY="ruby18"

DEPEND="
	>=dev-ruby/net-ssh-2.0.14
	>=dev-ruby/net-sftp-2.0.2
	>=dev-ruby/net-scp-1.0.2
	>=dev-ruby/net-ssh-gateway-1.0.0
	>=dev-ruby/highline-1.2.7"
RDEPEND="${DEPEND}"
PDEPEND="dev-ruby/capistrano-launcher"

src_install() {
	gems_src_install

	# Deleted cap, as it will be provided by capistrano-launcher
	rm "${D}/usr/bin/cap"
	rm "${D}/${GEMSDIR}/bin/cap"
}
